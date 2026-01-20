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
        <div class="color-button" data-color="#F247ED"></div>
        <div class="color-button" data-color="yellow"></div>
        <div class="color-button" data-color="#87CEEB"></div>
        <div class="memo-button" data-action="memo">
          <div class="memo-icon"></div>
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
      // if (TapTap.memo && TapTap.memo.memoUIElement.style.display === 'flex') return;

      if (this._tooltipRaf) cancelAnimationFrame(this._tooltipRaf);

      this._tooltipRaf = requestAnimationFrame(() => {
        const sel = window.getSelection();
        if (!sel || sel.rangeCount === 0) return;

        const range = sel.getRangeAt(0);
        if (range.collapsed) {
          this.hide();
          return;
        }
        this.show(range);
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

    this.hide();
     this.activeHighlightId = null;

    if (existingHighlightId) {
      if (color) {
        TapTap.highlight.updateHighlightColor(existingHighlightId, color);
      } else if (action === 'memo') {
        requestAnimationFrame(() => {
          TapTap.memo.showMemoInput(existingHighlightId);
        });
      }
      return;
    }

    const selection = window.getSelection();
    if (!selection || selection.rangeCount === 0 || selection.getRangeAt(0).collapsed) {
      return;
    }
    const range = selection.getRangeAt(0);

    if (color) {
      TapTap.highlight.highlightRange(range, color);
    } else if (action === 'memo') {
      const newHighlightId = TapTap.highlight.highlightRange(range, 'yellow'); // Default color
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
      range.selectNode(wrapper);
      
      this.isReopening = true;
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

    let currentColor = 'yellow';
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
