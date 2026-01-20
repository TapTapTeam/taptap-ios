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
        const highlightId = wrapper.dataset.highlightId;
        
        // [추가] 하이라이트에 메모가 있는지 확인합니다.
        const containerId = 'capsules-for-' + highlightId;
        const capsuleContainer = document.getElementById(containerId);
        const hasMemos = capsuleContainer && capsuleContainer.childElementCount > 0;

        // 하이라이트와 연결된 메모 컨테이너를 함께 삭제하는 함수
        const deleteHighlightAndMemos = () => {
          if (capsuleContainer) {
            capsuleContainer.remove();
          }
          TapTap.highlight.removeHighlight(highlightId);
        };

        if (hasMemos) {
          // [수정] 커스텀 확인창을 사용합니다.
          TapTap.customAlert.show(
            "메모가 있는 하이라이트입니다. 정말 삭제하시겠습니까?",
            () => { // 사용자가 '삭제'를 눌렀을 때 실행될 콜백 함수
              deleteHighlightAndMemos();
            }
          );
        } else {
          // 메모가 없으면, 바로 삭제합니다.
          deleteHighlightAndMemos();
        }
      } else {
        TapTap.sentence.selectSentenceAt(event);
      }
      
      event.preventDefault();
    }
    
    this.lastTapTime = currentTime;
  }
};

