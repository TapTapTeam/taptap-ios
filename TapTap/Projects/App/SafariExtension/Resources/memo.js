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
      this.saveMemo(activeHighlightId, memoText);

      if (editingMemoId) {
        // --- 수정 모드 ---
        const capsuleToUpdate = document.querySelector(`.memo-capsule[data-memo-id="${editingMemoId}"]`);
        if (capsuleToUpdate) {
          capsuleToUpdate.querySelector('.capsule-text').textContent = memoText;
          capsuleToUpdate.setAttribute('data-memo-text', memoText);
        }
      } else {
        // --- 생성 모드 ---
        this.renderMemoCapsule(activeHighlightId, memoText);
      }
    }
    
    // 입력창을 닫고, '수정 모드' 상태를 초기화합니다.
    event.target.value = '';
    delete this.memoUIElement.dataset.editingMemoId;
    this.hideMemoInput();
  },
  
  renderMemoCapsule: function(highlightId, memoText) {
    const wrapper = TapTap.highlight.getHighlightElementById(highlightId);
    if (!wrapper) return;

    // [수정] ID로 캡슐 컨테이너를 정확히 찾거나, 없으면 새로 만듭니다.
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
    const memoId = 'memo-' + Date.now() + '-' + Math.random().toString(36).slice(2, 7);

    const capsule = document.createElement('div');
    capsule.className = 'memo-capsule';
    capsule.setAttribute('data-highlight-color', normalized);
    capsule.setAttribute('data-memo-id', memoId);

    capsule.innerHTML = `
      <span class="capsule-text"></span>
      <button class="capsule-delete-btn" type="button" aria-label="Delete memo">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
          xmlns="http://www.w3.org/2000/svg">
          <path d="M18 6L6 18" stroke="currentColor" stroke-width="2"
            stroke-linecap="round" stroke-linejoin="round"/>
          <path d="M6 6L18 18" stroke="currentColor" stroke-width="2"
            stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </button>
    `;

    capsule.querySelector('.capsule-text').textContent = memoText;
    // [수정] 캡슐이 자신의 전체 메모 내용을 알도록 데이터 속성에 저장합니다.
    capsule.setAttribute('data-memo-text', memoText);

    capsule.addEventListener('click', (e) => {
      if (e.target.closest('.capsule-delete-btn')) return;
      
      // DOM 탐색으로 부모 하이라이트의 ID를 찾습니다.
      const wrapper = capsule.closest('.taptap-capsules-container')?.previousElementSibling;
      const highlightId = wrapper?.dataset.highlightId;
      const currentMemoText = capsule.dataset.memoText;

      if (highlightId) {
        // [수정] 콘솔 로그 대신, 에디터를 보여주는 함수를 호출합니다.
        const memoId = capsule.dataset.memoId;
        TapTap.memo.showMemoInput(highlightId, currentMemoText, memoId);
      }
    });

    capsule.querySelector('.capsule-delete-btn').addEventListener('click', (e) => {
      e.stopPropagation();
      capsule.remove();
      // TODO: 실제 저장소에서도 삭제
    });

    capsuleContainer.appendChild(capsule);
  },
  
  showMemoInput: function(highlightId, initialMemoText = "", editingMemoId = null) {
    const wrapper = TapTap.highlight.getHighlightElementById(highlightId);
    if (!wrapper) return;
    
    this.memoUIElement.dataset.activeHighlightId = highlightId;
    // [추가] 어떤 메모를 수정하고 있는지 ID를 저장하여 '수정 모드'임을 표시합니다.
    if (editingMemoId) {
      this.memoUIElement.dataset.editingMemoId = editingMemoId;
      // [추가] 수정 중인 캡슐에 'editing' 클래스를 추가하여 시각적으로 표시합니다.
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
    // [추가] 'editing' 상태였던 캡슐에서 클래스를 제거합니다.
    const currentlyEditingCapsule = document.querySelector('.memo-capsule.editing');
    if (currentlyEditingCapsule) {
      currentlyEditingCapsule.classList.remove('editing');
    }
    document.body.appendChild(this.memoUIElement);
  },

  saveMemo: function(highlightId, memoText) {
    console.log(`메모 저장! Highlight ID: ${highlightId}, 내용: "${memoText}"`);
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
