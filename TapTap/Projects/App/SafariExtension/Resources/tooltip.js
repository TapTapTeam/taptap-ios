//
//  tooltip.js
//  TapTap
//
//  Created by Hong on 1/20/26.
//

window.TapTap = window.TapTap || {};
TapTap.tooltip = {
  element: null,
  activeHighlightId: null,
  isReopening: false,

  init: function() {
    this.injectCSS('tooltip.css');
    this.element = document.createElement('div');
    this.element.id = 'taptap-tooltip';
    this.element.style.display = 'none';
    this.element.innerHTML = `
      <div class="tooltip-container">
        <div class="color-button" data-color="rgba(255, 85, 249, 0.2)"></div>
        <div class="color-button" data-color="rgba(255, 241, 39, 0.2)"></div>
        <div class="color-button" data-color="rgba(31, 180, 255, 0.2)"></div>
        <div class="memo-button" data-action="memo">
          <div class="memo-icon">
        <svg width="32" height="232" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path fill-rule="evenodd" clip-rule="evenodd" d="M12.328 7.02367L5.54608 13.8056L4.62106 17.2557L4.01261 19.5286C3.99571 19.5921 3.9958 19.6589 4.01286 19.7224C4.02992 19.7859 4.06336 19.8437 4.10982 19.8902C4.15628 19.9366 4.21414 19.9701 4.2776 19.9871C4.34105 20.0042 4.40788 20.0043 4.47138 19.9874L6.74276 19.3782L10.1936 18.4532H10.1944L16.9763 11.6712L12.3288 7.02367H12.328ZM19.7806 7.80949L16.1913 4.21943C16.1218 4.14987 16.0393 4.09469 15.9486 4.05703C15.8578 4.01938 15.7604 4 15.6621 4C15.5639 4 15.4665 4.01938 15.3757 4.05703C15.2849 4.09469 15.2025 4.14987 15.133 4.21943L13.2807 6.07096L17.929 10.7193L19.7806 8.86697C19.8501 8.79753 19.9053 8.71505 19.943 8.62426C19.9806 8.53347 20 8.43614 20 8.33785C20 8.23956 19.9806 8.14224 19.943 8.05145C19.9053 7.96066 19.8501 7.87818 19.7806 7.80874" fill="#5C5C6E"></path>
            </svg>
          </div>
        </div>
      </div>
    `;
    document.body.appendChild(this.element);

    this.element.addEventListener('mousedown', this.handleTooltipMouseDown.bind(this));
    document.addEventListener('click', this.handleExternalClick.bind(this), true);
    this._tooltipRaf = null;

    document.addEventListener('selectionchange', () => {
      if (this.isReopening) return;
      if (this.element.style.display !== 'block') return;
      if (this._tooltipRaf) cancelAnimationFrame(this._tooltipRaf);

      this._tooltipRaf = requestAnimationFrame(() => {
        const sel = window.getSelection();
        if (!sel || sel.rangeCount === 0) return;

        const range = sel.getRangeAt(0);
        if (range.collapsed) {
          this.hide();
          return;
        }
        this.show(range, this.activeHighlightId);
      });
    });
  },

  handleTooltipMouseDown: function(event) {
    event.preventDefault();
    event.stopPropagation();

    const target = event.target.closest('[data-color], [data-action]');
    if (!target) return;

    const color = target.dataset.color;
    const action = target.dataset.action;
    const existingHighlightId = this.activeHighlightId;

    // ✅ iOS에서 hide()하면 selection이 바로 collapse될 수 있어서 먼저 range를 "복사"해둔다
    let preservedRange = null;
    const selection = window.getSelection();
    if (selection && selection.rangeCount > 0) {
      const r = selection.getRangeAt(0);
      if (!r.collapsed) preservedRange = r.cloneRange();
    }

    // ✅ hide는 range 확보 후에
    this.hide();
    this.activeHighlightId = null;

    if (existingHighlightId) {
      if (color) {
        // ✅ selection이 살아있을 때 복사한 range를 쓰기
        if (preservedRange) {
          TapTap.highlight.replaceHighlight(existingHighlightId, preservedRange, color);
        } else {
          TapTap.highlight.updateHighlightColor(existingHighlightId, color);
        }
      } else if (action === 'memo') {
        const currentColor = TapTap.highlight.getHighlightColor(existingHighlightId) || 'yellow';
        // 영역 업데이트 후 메모 열기
        const rangeToUse = preservedRange || (window.getSelection().rangeCount > 0 ? window.getSelection().getRangeAt(0) : null);
        if (rangeToUse) {
           const updatedId = TapTap.highlight.replaceHighlight(existingHighlightId, rangeToUse, currentColor);
           requestAnimationFrame(() => {
             TapTap.memo.showMemoInput(updatedId);
           });
        }
      }
      return;
    }

    // 새 하이라이트 생성도 preservedRange 우선 사용
    if (!preservedRange) return;

    if (color) {
      TapTap.highlight.highlightRange(preservedRange, color);
    } else if (action === 'memo') {
      const newHighlightId = TapTap.highlight.highlightRange(preservedRange, 'rgba(255, 241, 39, 0.2)');
      if (newHighlightId) {
        requestAnimationFrame(() => {
          TapTap.memo.showMemoInput(newHighlightId);
        });
      }
    }
  },

  handleExternalClick: function(event) {
    const wrapper = event.target.closest('.taptap-wrapper');
    if (wrapper) {
      event.preventDefault();
      event.stopPropagation();

      const highlightId = wrapper.dataset.highlightId;
      const range = document.createRange();
      const highlightedSpan = wrapper.querySelector('.taptap-highlighted');
      if (highlightedSpan) range.selectNodeContents(highlightedSpan);
      else range.selectNodeContents(wrapper);

      const sel = window.getSelection();
      sel.removeAllRanges();
      sel.addRange(range);

      this.show(range, highlightId);
      setTimeout(() => { this.isReopening = false; }, 100);

      return;
    }

    if (this.element.style.display === 'block' && !this.element.contains(event.target)) {
      const selection = window.getSelection();
      if (selection.isCollapsed) {
          this.hide();
      }
    }
  },

  injectCSS: function(file) {
    fetch(browser.runtime.getURL(file))
      .then(response => response.text())
      .then(css => {
        const style = document.createElement('style');
        style.textContent = css;
        document.head.appendChild(style);
      })
      .catch(err => console.error("Failed to inject CSS:", err));
  },

  show: function(range, highlightId = null) {
    if (!range) return;
    this.activeHighlightId = highlightId;

    const rect = range.getBoundingClientRect();
    if (rect.width === 0 && rect.height === 0) return;

    const colorButtons = this.element.querySelectorAll('.color-button');
    colorButtons.forEach(button => button.classList.remove('selected'));

    let currentColor = null;
    if (this.activeHighlightId) {
      const highlightBgColor = TapTap.highlight.getHighlightColor(this.activeHighlightId);
      if (highlightBgColor) {
        currentColor = this.normalizeColor(highlightBgColor);
      }
    }

    const selectedButton = Array.from(colorButtons).find(
      button => this.normalizeColor(button.dataset.color) === currentColor
    );
    if (selectedButton) {
      selectedButton.classList.add('selected');
    }

    this.element.style.display = 'block';
    this.element.style.top = (window.scrollY + rect.bottom + 23) + 'px';
    this.element.style.left =
      (window.scrollX + (window.innerWidth / 2) - (this.element.offsetWidth / 2)) + 'px';
  },

  normalizeColor: function(color) {
    if (!color) return null;
    const lowerColor = color.toLowerCase();
    switch (lowerColor) {
      case 'rgb(242, 71, 237)': return '#f247ed';
      case 'rgb(255, 255, 0)':
      case 'yellow':           return 'yellow';
      case 'rgb(135, 206, 235)': return '#87ceeb';
      case '#f247ed': return '#f247ed';
      case '#87ceeb': return '#87ceeb';
      case '#ffe0f7': return '#ffe0f7';
      case '#fef8cd': return '#fef8cd';
      case '#dbf3ff': return '#dbf3ff';
      default: return lowerColor;
    }
  },

  hide: function() {
    this.element.style.display = 'none';
  }
};
