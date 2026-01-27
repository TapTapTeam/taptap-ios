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
    const highlightedSpan = wrapper.querySelector('.taptap-highlighted');

    if (highlightedSpan) {
      range.selectNodeContents(highlightedSpan);
    } else {
      range.selectNodeContents(wrapper);
    }
    
    const selection = window.getSelection();
    selection.removeAllRanges();
    selection.addRange(range);
    
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
    this._updateSharedDom(highlights); // DOM에 데이터 저장
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

      // 중첩 방지: 내부의 기존 하이라이트 태그를 벗겨내어 색상 혼합을 막음
      const existingHighlights = contents.querySelectorAll('.taptap-wrapper, .taptap-highlighted');
      existingHighlights.forEach(el => {
        const parent = el.parentNode;
        while (el.firstChild) {
          parent.insertBefore(el.firstChild, el);
        }
        el.remove();
      });
      
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
      this._updateSharedDom(highlights); // DOM에 데이터 저장
    }
  },

  replaceHighlight: function(id, newRange, newColor) {
    // 1. 기존 데이터(메모 등) 백업
    const pageKey = 'taptap-highlights-' + window.location.href;
    const highlights = JSON.parse(localStorage.getItem(pageKey) || '[]');
    const oldHighlight = highlights.find(h => h.id === id);
    const oldMemos = oldHighlight ? oldHighlight.memos : [];

    // 2. 새 하이라이트 생성 (Range가 유효할 때 먼저 생성)
    // 임시 ID로 생성 후 나중에 원본 ID로 교체합니다.
    const tempId = this.highlightRange(newRange, newColor); 
    if (!tempId) return null;

    // 3. 기존 하이라이트 삭제 (이제 Range가 깨져도 상관없음)
    this.removeHighlight(id);
    
    // 4. 새 하이라이트의 ID를 원본 ID로 교체 및 메모 복구
    const newWrapper = this.getHighlightElementById(tempId);
    if (newWrapper) {
        newWrapper.dataset.highlightId = id;
        const span = newWrapper.querySelector('.taptap-highlighted');
        if (span) span.setAttribute('highlightid', id);
    }

    const currentHighlights = JSON.parse(localStorage.getItem(pageKey) || '[]');
    const tempHighlightEntry = currentHighlights.find(h => h.id === tempId);
    
    if (tempHighlightEntry) {
        tempHighlightEntry.id = id; // ID 복구
        if (oldMemos && oldMemos.length > 0) {
            tempHighlightEntry.memos = oldMemos; // 메모 복구
        }
        localStorage.setItem(pageKey, JSON.stringify(currentHighlights));
        this._updateSharedDom(currentHighlights);
        
        // 화면에 메모 캡슐 다시 그리기
        if (oldMemos && oldMemos.length > 0) {
            oldMemos.forEach(memo => {
                TapTap.memo.renderMemoCapsule(id, memo);
            });
        }
    }
    
    return id;
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
      this.removeHighlightElement(wrapper);
    } else {
      console.warn(`removeHighlight: ID가 ${id}인 하이라이트 요소를 찾을 수 없습니다.`);
      // 요소가 없더라도 데이터상에는 존재할 수 있으므로 데이터 삭제 로직은 수행
      this._removeHighlightData(id);
    }
  },

  removeHighlightElement: function(wrapper) {
    if (!wrapper) return;
    
    const id = wrapper.dataset.highlightId;
    console.log("removeHighlightElement 실행:", id);

    // 연결된 메모 컨테이너도 함께 삭제 (중복 렌더링 방지)
    if (id) {
        const capsuleContainer = document.getElementById('capsules-for-' + id);
        if (capsuleContainer) {
            capsuleContainer.remove();
        }
    }

    // 1. DOM에서 언래핑 (텍스트 복원)
    const parent = wrapper.parentNode;
    while (wrapper.firstChild) {
      // wrapper 내부의 span을 벗겨내고 텍스트만 추출해야 함
      // 현재 구조: wrapper > span > text
      // 목표: parent > text
      
      const child = wrapper.firstChild;
      if (child.nodeType === Node.ELEMENT_NODE && child.classList.contains('taptap-highlighted')) {
         // span 내부의 텍스트 노드들을 wrapper의 형제로 이동
         while (child.firstChild) {
           parent.insertBefore(child.firstChild, wrapper);
         }
         child.remove(); // 빈 span 삭제
      } else {
         // 혹시 span 없이 텍스트만 있는 경우 (비정상 케이스 대비)
         parent.insertBefore(child, wrapper);
      }
    }
    wrapper.remove();

    // 2. 데이터 삭제
    if (id) {
      this._removeHighlightData(id);
    }
  },

  _removeHighlightData: function(id) {
    const pageKey = 'taptap-highlights-' + window.location.href;
    let highlights = JSON.parse(localStorage.getItem(pageKey) || '[]');
    highlights = highlights.filter(h => h.id !== id);
    localStorage.setItem(pageKey, JSON.stringify(highlights));
    this._updateSharedDom(highlights); 
  },
  
  restoreHighlights: function() {
    const pageKey = 'taptap-highlights-' + window.location.href;
    const highlights = JSON.parse(localStorage.getItem(pageKey) || '[]');
    this._updateSharedDom(highlights); // DOM에 데이터 저장
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
  },
  
  _updateSharedDom: function(highlights) {
    let sharedDiv = document.getElementById('taptap-data-for-share');
    if (!sharedDiv) {
      sharedDiv = document.createElement('div');
      sharedDiv.id = 'taptap-data-for-share';
      sharedDiv.style.display = 'none';
      document.body.appendChild(sharedDiv);
    }
    sharedDiv.textContent = JSON.stringify(highlights);
  }
};
