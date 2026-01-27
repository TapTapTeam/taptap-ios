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
  },
  
  handleTouchEnd: function(event) {
    const currentTime = new Date().getTime();
    const timeSinceLastTap = currentTime - this.lastTapTime;
    
    if (timeSinceLastTap < 300 && timeSinceLastTap > 0) {
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
    
    this.lastTapTime = currentTime;
  }
};

