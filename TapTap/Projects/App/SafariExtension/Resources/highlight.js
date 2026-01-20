//
//  highlight.js
//  TapTap
//
//  Created by Hong on 1/20/26.
//

window.TapTap = window.TapTap || {};
TapTap.highlight = {
  init: function() {
    document.body.addEventListener('click', this.handleHighlightClick.bind(this));
  },

  handleHighlightClick: function(event) {
    const wrapper = event.target.closest('.taptap-wrapper');
    if (!wrapper) return;

    if (TapTap.tooltip.element.style.display === 'block' || TapTap.tooltip.memoUIElement.style.display === 'flex') {
      return;
    }
    
    event.preventDefault();
    event.stopPropagation();

    TapTap.tooltip.isReopening = true;

    const highlightId = wrapper.dataset.highlightId;
    const range = document.createRange();
    range.selectNode(wrapper);
    TapTap.tooltip.show(range, highlightId);

    requestAnimationFrame(() => {
      TapTap.tooltip.isReopening = false;
    });
  },

  highlightRange: function(range, color, highlightId = 'taptap-' + Math.random().toString(36).substr(2, 9)) {
    if (!range || range.collapsed) {
      return null;
    }
    
    try {
      const highlightedTextSpan = document.createElement('span');
      highlightedTextSpan.classList.add('taptap-highlighted');
      highlightedTextSpan.style.fontWeight = 'inherit !important';
      highlightedTextSpan.style.fontStyle = 'inherit !important';
      highlightedTextSpan.style.lineHeight = 'inherit !important';
      highlightedTextSpan.style.backgroundColor = color || 'yellow';
      highlightedTextSpan.style.cursor = 'pointer !important';
      highlightedTextSpan.setAttribute('highlightid', highlightId);
      
      const wrapper = document.createElement('div');
      wrapper.classList.add('taptap-wrapper');
      wrapper.setAttribute('data-highlight-id', highlightId);
      wrapper.style.display = 'inline';
      wrapper.style.position = 'relative';
      
      const contents = range.extractContents();
      highlightedTextSpan.appendChild(contents);
      wrapper.appendChild(highlightedTextSpan);
      
      range.insertNode(wrapper);
      window.getSelection().removeAllRanges();
      
      console.log("highlightRange - Highlight ID returned:", highlightId);
      return highlightId;
    } catch (e) {
      console.error("하이라이트 생성 중 오류 발생:", e);
      window.getSelection().removeAllRanges();
      return null;
    }
  },
  
  getHighlightElementById: function(id) {
    return document.querySelector(`div.taptap-wrapper[data-highlight-id="${id}"]`);
  },
  
  updateHighlightColor: function(id, color) {
    const wrapper = this.getHighlightElementById(id);
    if (!wrapper) return;

    // 1. 하이라이트 자체의 색상 변경
    const highlightedTextSpan = wrapper.querySelector('span.taptap-highlighted');
    if (highlightedTextSpan) {
      highlightedTextSpan.style.backgroundColor = color;
    }

    // 2. 연결된 메모 캡슐들의 색상 변경
    const containerId = 'capsules-for-' + id;
    const capsuleContainer = document.getElementById(containerId);
    if (capsuleContainer) {
      const capsules = capsuleContainer.querySelectorAll('.memo-capsule');
      const normalizedColor = TapTap.tooltip.normalizeColor(color);
      capsules.forEach(capsule => {
        capsule.setAttribute('data-highlight-color', normalizedColor);
      });
    }
  },

  getHighlightColor: function(id) {
    const wrapper = this.getHighlightElementById(id);
    if (wrapper) {
      const highlightedTextSpan = wrapper.querySelector('span.taptap-highlighted');
      if (highlightedTextSpan) {
        return highlightedTextSpan.style.backgroundColor;
      }
    }
    return null;
  },
  
  removeHighlight: function(id) {
    const wrapper = this.getHighlightElementById(id);
    if (wrapper) {
      const highlightedTextSpan = wrapper.querySelector('span.taptap-highlighted');
      while (highlightedTextSpan.firstChild) {
        wrapper.insertBefore(highlightedTextSpan.firstChild, highlightedTextSpan);
      }
      highlightedTextSpan.remove();
      const parent = wrapper.parentNode;
      while (wrapper.firstChild) {
        parent.insertBefore(wrapper.firstChild, wrapper);
      }
      wrapper.remove();
    }
  }
};
