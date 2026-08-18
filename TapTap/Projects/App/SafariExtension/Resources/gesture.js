//
//  gesture.js
//  TapTap
//
//  Created by Hong on 1/20/26.
//

window.TapTap = window.TapTap || {};
TapTap.gesture = {
  lastTapTime: 0,
  
  init: function() {
    document.addEventListener('touchend', this.handleTouchEnd.bind(this), false);
    if (!('ontouchend' in window)) {
      document.addEventListener('dblclick', this.handleDoubleTap.bind(this), false);
      // macOS: 트랙패드 드래그(세 손가락 드래그 포함)·마우스 드래그로 텍스트를 선택하면 툴팁을 띄운다.
      // iOS는 더블탭 문장 선택이 유일한 진입점이라 touch 환경에서는 등록하지 않는다.
      document.addEventListener('mouseup', this.handleMouseUpSelection.bind(this), false);
    }
  },

  handleMouseUpSelection: function(event) {
    if (event.button !== 0) return; // 우클릭(컨텍스트 메뉴) 등은 무시

    // 툴팁·메모·알럿 위에서 끝난 드래그는 무시 (툴팁 버튼은 mousedown에서 이미 처리됨)
    const tooltip = TapTap.tooltip;
    const memoUI = TapTap.memo && TapTap.memo.memoUIElement;
    if (!tooltip || !tooltip.element) return;
    if (tooltip.element.contains(event.target)) return;
    if (memoUI && memoUI.contains(event.target)) return;
    if (event.target.closest && event.target.closest('#taptap-custom-alert-overlay')) return;

    // 같은 mouseup에 이어지는 click/dblclick(하이라이트 클릭·문장 선택)이 먼저 처리되도록 한 틱 미룬다.
    setTimeout(() => {
      if (tooltip.element.style.display === 'block') return;
      if (memoUI && memoUI.style.display === 'flex') return;

      const selection = window.getSelection();
      if (!selection || selection.rangeCount === 0 || selection.isCollapsed) return;

      const range = selection.getRangeAt(0);
      if (!range.toString().trim()) return;

      // 선택 영역이 기존 하이라이트 하나 안에 있으면 새로 만들지 않고 그 하이라이트 편집으로 연다.
      let ancestor = range.commonAncestorContainer;
      if (ancestor.nodeType !== Node.ELEMENT_NODE) ancestor = ancestor.parentElement;
      const wrapper = ancestor ? ancestor.closest('.taptap-wrapper') : null;

      tooltip.show(range, wrapper ? wrapper.dataset.highlightId : null);
    }, 0);
  },

  handleTouchEnd: function(event) {
    const currentTime = new Date().getTime();
    const timeSinceLastTap = currentTime - this.lastTapTime;

    if (timeSinceLastTap < 300 && timeSinceLastTap > 0) {
      this.handleDoubleTap(event);
    }

    this.lastTapTime = currentTime;
  },

  handleDoubleTap: function(event) {
      console.log("더블탭 감지됨");

      const wrapper = event.target.closest('.taptap-wrapper');
      
      if (wrapper) {
        // 1. 더블탭 동작이므로 열려있을 수 있는 툴팁을 즉시 닫아 겹침 현상 방지
        if (TapTap.tooltip && TapTap.tooltip.hide) {
            TapTap.tooltip.hide();
        }

        const highlightId = wrapper.dataset.highlightId;
        const containerId = 'capsules-for-' + highlightId;
        const capsuleContainer = document.getElementById(containerId);
        
        // 메모가 실제로 존재하는지 확인
        const hasMemos = capsuleContainer && capsuleContainer.childElementCount > 0;

        const deleteHighlightAndMemos = () => {
          if (capsuleContainer) {
            capsuleContainer.remove();
          }
          // 안정적인 Element 직접 전달 방식으로 삭제
          if (TapTap.highlight && TapTap.highlight.removeHighlightElement) {
            TapTap.highlight.removeHighlightElement(wrapper);
          } else {
            TapTap.highlight.removeHighlight(highlightId);
          }
        };

        if (hasMemos) {
          TapTap.customAlert.show(
            "삭제한 메모는 복구할 수 없어요",
            () => {
              deleteHighlightAndMemos();
            }
          );
        } else {
          deleteHighlightAndMemos();
        }
        
        // 이벤트 중복 처리 방지
        event.preventDefault();
        event.stopPropagation();
        
      } else {
        TapTap.sentence.selectSentenceAt(event);
        event.preventDefault();
      }
  }
};

