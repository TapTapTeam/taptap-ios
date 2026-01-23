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

        const containerId = 'capsules-for-' + highlightId;
        const capsuleContainer = document.getElementById(containerId);
        const hasMemos = capsuleContainer && capsuleContainer.childElementCount > 0;

        const deleteHighlightAndMemos = () => {
          if (capsuleContainer) {
            capsuleContainer.remove();
          }
          TapTap.highlight.removeHighlight(highlightId);
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
      } else {
        TapTap.sentence.selectSentenceAt(event);
      }
      event.preventDefault();
    }
    
    this.lastTapTime = currentTime;
  }
};

