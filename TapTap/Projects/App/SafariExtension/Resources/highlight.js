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
    
    const wrapper = this._renderHighlight(range, color, highlightId);
    if (!wrapper) return null;
    
    const pageKey = 'taptap-highlights-' + window.location.href;
    const highlights = JSON.parse(localStorage.getItem(pageKey) || '[]');
    
    const newHighlight = {
      id: highlightId,
      text: wrapper.textContent,
      color: color,
      createdAt: new Date().toISOString(),
      memos: []
    };
    
    highlights.push(newHighlight);
    localStorage.setItem(pageKey, JSON.stringify(highlights));
    
    window.getSelection().removeAllRanges();
    return highlightId;
  },
  
  _renderHighlight: function(range, color, highlightId) {
    try {
      const highlightedTextSpan = document.createElement('span');
      highlightedTextSpan.classList.add('taptap-highlighted');
      highlightedTextSpan.style.backgroundColor = color || 'yellow';
      highlightedTextSpan.setAttribute('highlightid', highlightId);
      
      const wrapper = document.createElement('div');
      wrapper.classList.add('taptap-wrapper');
      wrapper.setAttribute('data-highlight-id', highlightId);
      wrapper.style.display = 'inline';
      
      const contents = range.extractContents();
      highlightedTextSpan.appendChild(contents);
      wrapper.appendChild(highlightedTextSpan);
      
      range.insertNode(wrapper);
      return wrapper;
    } catch (e) {
      console.error("하이라이트 렌더링 중 오류 발생:", e);
      return null;
    }
  },
  
  getHighlightElementById: function(id) {
    return document.querySelector(`div.taptap-wrapper[data-highlight-id="${id}"]`);
  },
  
  updateHighlightColor: function(id, color) {
    const wrapper = this.getHighlightElementById(id);
    if (!wrapper) return;
    
    const highlightedTextSpan = wrapper.querySelector('span.taptap-highlighted');
    if (highlightedTextSpan) {
      highlightedTextSpan.style.backgroundColor = color;
    }
    
    const pageKey = 'taptap-highlights-' + window.location.href;
    const highlights = JSON.parse(localStorage.getItem(pageKey) || '[]');
    const highlight = highlights.find(h => h.id === id);
    if (highlight) {
      highlight.color = color;
      localStorage.setItem(pageKey, JSON.stringify(highlights));
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
      const parent = wrapper.parentNode;
      while (wrapper.firstChild) {
        parent.insertBefore(wrapper.firstChild, wrapper);
      }
      wrapper.remove();
    }
    
    const pageKey = 'taptap-highlights-' + window.location.href;
    let highlights = JSON.parse(localStorage.getItem(pageKey) || '[]');
    highlights = highlights.filter(h => h.id !== id);
    localStorage.setItem(pageKey, JSON.stringify(highlights));
  },
  
  restoreHighlights: function() {
    const pageKey = 'taptap-highlights-' + window.location.href;
    const highlights = JSON.parse(localStorage.getItem(pageKey) || '[]');
    
    if (highlights.length === 0) return;
    
    const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT, null, false);
    let textNodes = [];
    while(walker.nextNode()) {
      const node = walker.currentNode;
      if (node.nodeValue.trim() !== '' && !['STYLE', 'SCRIPT', 'NOSCRIPT'].includes(node.parentNode.tagName)) {
        textNodes.push(node);
      }
    }
    
    highlights.forEach(h => {
      for (const node of textNodes) {
        const index = node.nodeValue.indexOf(h.text);
        if (index !== -1) {
          try {
            const range = document.createRange();
            range.setStart(node, index);
            range.setEnd(node, index + h.text.length);
            
            this._renderHighlight(range, h.color, h.id);
            
            if (h.memos && h.memos.length > 0) {
              h.memos.forEach(memo => {
                TapTap.memo.renderMemoCapsule(h.id, memo);
              });
            }
            
            break;
          } catch (e) {
            console.error("하이라이트 복원 중 오류:", e);
          }
        }
      }
    });
  }
};
