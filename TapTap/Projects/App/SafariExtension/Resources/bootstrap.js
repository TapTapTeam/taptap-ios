//
//  bootstrap.js
//  TapTap
//
//  Created by Hong on 1/20/26.
//

window.TapTap = window.TapTap || {};
const TapTap = window.TapTap;
function initializeWhenReady(tryCount = 0) {
  if (!TapTap.gesture || !TapTap.highlight || !TapTap.tooltip) {
    if (tryCount > 50) {
      return;
    }
    setTimeout(() => initializeWhenReady(tryCount + 1), 20);
    return;
  }
 
  TapTap.gesture.init();
  TapTap.highlight.init();
  TapTap.tooltip.init();
  TapTap.memo?.init?.();
  TapTap.customAlert?.init?.();
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => initializeWhenReady());
} else {
  initializeWhenReady();
}
