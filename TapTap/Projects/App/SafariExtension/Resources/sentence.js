//
//  sentence.js
//  TapTap
//
//  Created by Hong on 1/20/26.
//

window.TapTap = window.TapTap || {};
TapTap.sentence = {
  selectSentenceAt: function(event) {
    const point = event.changedTouches ? event.changedTouches[0] : event;
    const x = point.clientX;
    const y = point.clientY;

    const range = document.caretRangeFromPoint(x, y);

    if (range && range.startContainer) {
      const textNode = range.startContainer;
      const offset = range.startOffset;

      if (textNode.nodeType === Node.TEXT_NODE) {
        const textContent = textNode.textContent ?? "";
        const sentenceEndChars = ".?!…\n";

        let start = offset;
        while (start > 0) {
          if (sentenceEndChars.includes(textContent[start - 1])) {
            break;
          }
          start--;
        }

        if (textContent[start] === ' ') {
          start++;
        }

        let end = offset;
        while (end < textContent.length) {
          if (sentenceEndChars.includes(textContent[end])) {
            end++;
            break;
          }
          end++;
        }

        const selection = window.getSelection();
        selection.removeAllRanges();

        const newRange = document.createRange();
        newRange.setStart(textNode, start);
        newRange.setEnd(textNode, end);
        selection.addRange(newRange);

        TapTap.tooltip.show(newRange);
      }
    }
  }
};
