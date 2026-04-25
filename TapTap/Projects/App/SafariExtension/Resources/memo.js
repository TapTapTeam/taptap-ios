//
//  memo.js
//  TapTap
//
//  Created by Hong on 1/20/26.
//

window.TapTap = window.TapTap || {};
TapTap.memo = {
  memoUIElement: null,

  init: function() {
    this.injectCSS('memo.css');
    this.memoUIElement = document.createElement('div');
    this.memoUIElement.id = 'memo-box';
    this.memoUIElement.style.display = 'none';
    this.memoUIElement.innerHTML = `
      <textarea class="capsule-input-textarea" placeholder="중요한 내용이나 생각을 입력해보세요"></textarea>
    `;
    document.body.appendChild(this.memoUIElement);
    
    this.memoUIElement.addEventListener('touchend', (e) => e.stopPropagation(), { capture: true });
    this.memoUIElement.addEventListener('touchstart', (e) => e.stopPropagation(), { capture: true });
    
    const memoTextarea = this.memoUIElement.querySelector('.capsule-input-textarea');
    if (memoTextarea) {
      memoTextarea.addEventListener('blur', this.handleMemoBlur.bind(this));
    }
    document.addEventListener('click', this.handleExternalClick.bind(this), true);
  },

  handleExternalClick: function(event) {
    if (this.memoUIElement.style.display === 'flex' && !this.memoUIElement.contains(event.target)) {
        this.hideMemoInput();
    }
  },

  handleMemoBlur: function(event) {
    const memoText = event.target.value.trim();
    const activeHighlightId = this.memoUIElement.dataset.activeHighlightId;
    const editingMemoId = this.memoUIElement.dataset.editingMemoId;

    if (activeHighlightId && memoText) {
      const savedMemo = this.saveMemo(activeHighlightId, memoText, editingMemoId);

      if (editingMemoId) {
        const capsuleToUpdate = document.querySelector(`.memo-capsule[data-memo-id="${editingMemoId}"]`);
        if (capsuleToUpdate) {
          capsuleToUpdate.querySelector('.capsule-text').textContent = memoText;
          capsuleToUpdate.setAttribute('data-memo-text', memoText);
        }
      } else if (savedMemo){
        this.renderMemoCapsule(activeHighlightId, savedMemo);
      }
    }
    
    event.target.value = '';
    delete this.memoUIElement.dataset.editingMemoId;
    this.hideMemoInput();
  },
  
  renderMemoCapsule: function(highlightId, memo) {
    const wrapper = TapTap.highlight.getHighlightElementById(highlightId);
    if (!wrapper) return;

    const containerId = 'capsules-for-' + highlightId;
    let capsuleContainer = document.getElementById(containerId);

    if (!capsuleContainer) {
      capsuleContainer = document.createElement('div');
      capsuleContainer.id = containerId;
      capsuleContainer.className = 'taptap-capsules-container';
      wrapper.parentNode.insertBefore(capsuleContainer, wrapper.nextSibling);
    }

    const highlightColor = TapTap.highlight.getHighlightColor(highlightId) || 'yellow';
    const normalized = TapTap.tooltip.normalizeColor(highlightColor);
    
    const memoId = memo.id;
    const memoText = memo.text;

    const capsule = document.createElement('div');
    capsule.className = 'memo-capsule';
    capsule.setAttribute('data-highlight-color', normalized);
    capsule.setAttribute('data-memo-id', memoId);

    capsule.innerHTML = `
      <span class="capsule-text"></span>
      <button class="capsule-delete-btn" type="button" aria-label="Delete memo">
        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="none" viewBox="0 0 32 32"><path stroke="#71717a" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.25" d="M21 11 11 21M11 11l10 10"/></svg>
      </button>
    `;

    capsule.querySelector('.capsule-text').textContent = memoText;
    capsule.setAttribute('data-memo-text', memoText);

    capsule.addEventListener('click', (e) => {
      if (e.target.closest('.capsule-delete-btn')) return;
      
      const wrapper = capsule.closest('.taptap-capsules-container')?.previousElementSibling;
      const highlightId = wrapper?.dataset.highlightId;
      const currentMemoText = capsule.dataset.memoText;

      if (highlightId) {
        const memoId = capsule.dataset.memoId;
        TapTap.memo.showMemoInput(highlightId, currentMemoText, memoId);
      }
    });

    capsule.querySelector('.capsule-delete-btn').addEventListener('click', (e) => {
      e.stopPropagation();
      const highlightId = capsule.closest('.taptap-capsules-container')?.previousElementSibling?.dataset.highlightId;
      const memoId = capsule.dataset.memoId;
      if(highlightId && memoId) {
        this.deleteMemo(highlightId, memoId);
      }
      capsule.remove();
    });

    capsuleContainer.appendChild(capsule);
  },
  
  showMemoInput: function(highlightId, initialMemoText = "", editingMemoId = null) {
    const wrapper = TapTap.highlight.getHighlightElementById(highlightId);
    if (!wrapper) return;
    
    this.memoUIElement.dataset.activeHighlightId = highlightId;
    if (editingMemoId) {
      this.memoUIElement.dataset.editingMemoId = editingMemoId;
      const editingCapsule = document.querySelector(`.memo-capsule[data-memo-id="${editingMemoId}"]`);
      if (editingCapsule) {
        editingCapsule.classList.add('editing');
      }
    }

    wrapper.parentNode.insertBefore(this.memoUIElement, wrapper.nextSibling);
    const textarea = this.memoUIElement.querySelector('.capsule-input-textarea');
    if (textarea) {
      textarea.value = initialMemoText;
      textarea.focus();
    }
    this.memoUIElement.style.display = 'flex';
  },

  hideMemoInput: function() {
    this.memoUIElement.style.display = 'none';
    this.memoUIElement.dataset.activeHighlightId = '';
    const currentlyEditingCapsule = document.querySelector('.memo-capsule.editing');
    if (currentlyEditingCapsule) {
      currentlyEditingCapsule.classList.remove('editing');
    }
    document.body.appendChild(this.memoUIElement);
  },

  saveMemo: function(highlightId, memoText, memoId = null) {
    const pageKey = TapTap.highlight._getPageKey();
    const highlights = JSON.parse(localStorage.getItem(pageKey) || '[]');
    const highlight = highlights.find(h => h.id === highlightId);

    if (!highlight) return null;

    if (!highlight.memos) {
      highlight.memos = [];
    }

    let memoToSave;
    if (memoId) {
      memoToSave = highlight.memos.find(m => m.id === memoId);
      if (memoToSave) {
        memoToSave.text = memoText;
      }
    } else {
      memoToSave = {
        id: Date.now(), // Double 타입의 ID를 위해 Date.now() 사용
        type: "General", // 기본 타입 추가
        text: memoText
      };
      highlight.memos.push(memoToSave);
    }
    
    localStorage.setItem(pageKey, JSON.stringify(highlights));
    TapTap.highlight._updateSharedDom(highlights); // DOM에 데이터 저장
    return memoToSave;
  },
  
  deleteMemo: function(highlightId, memoId) {
      const pageKey = TapTap.highlight._getPageKey();
      const highlights = JSON.parse(localStorage.getItem(pageKey) || '[]');
      const highlight = highlights.find(h => h.id === highlightId);

      if (highlight && highlight.memos) {
          highlight.memos = highlight.memos.filter(m => m.id !== memoId);
          localStorage.setItem(pageKey, JSON.stringify(highlights));
          TapTap.highlight._updateSharedDom(highlights); // DOM에 데이터 저장
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
};
