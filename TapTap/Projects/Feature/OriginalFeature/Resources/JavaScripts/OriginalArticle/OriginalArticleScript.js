let currentMemoBox = null;

function renderCapsules(span, comments) {
  if (!comments || comments.length === 0) return;

  const parentType = (span.dataset.highlightType || "").toLowerCase() || "detail";

  const container = document.createElement('div');
  container.className = 'capsule-container';
  span.after(container);

  comments.forEach(comment => {
    const capsule = document.createElement('div');
    capsule.className = 'memo-capsule';

    capsule.dataset.memoType = parentType;

    const textPreview = document.createElement('span');
    textPreview.className = 'capsule-text';
    textPreview.textContent = comment.text;
    capsule.appendChild(textPreview);

    capsule.addEventListener('click', (e) => {
      e.stopPropagation();
      const isAlreadyClicked = capsule.classList.contains(`clicked-${parentType}`);

      document.querySelectorAll('.memo-capsule.clicked-what, .memo-capsule.clicked-why, .memo-capsule.clicked-detail')
        .forEach(c => c.classList.remove('clicked-what', 'clicked-why', 'clicked-detail'));

      if (isAlreadyClicked) {
        if (currentMemoBox) currentMemoBox.remove();
        currentMemoBox = null;
        return;
      }

      capsule.classList.add(`clicked-${parentType}`);
      showMemoBox(span, comment);
    });

    container.appendChild(capsule);
  });
}

function showMemoBox(targetElement, comment) {
  if (currentMemoBox) {
    currentMemoBox.remove();
  }
  
  const memoBox = document.createElement('div');
  memoBox.id = 'memo-box';
  memoBox.dataset.editingId = comment.id;
  memoBox.addEventListener('click', e => e.stopPropagation());
  
  const commentDisplay = document.createElement('div');
  commentDisplay.className = 'memo-box-content';
  commentDisplay.textContent = comment.text;
  memoBox.appendChild(commentDisplay);
  
  targetElement.after(memoBox);
  
  currentMemoBox = memoBox;
}

function applyHighlights(highlights) {
 
  if (typeof highlights === "string") {
    try { highlights = JSON.parse(highlights); }
    catch (e) { console.error("JSON parse fail", e); return; }
  }
  
  if (!highlights || highlights.length === 0) return;
  
  for (const h of highlights) {
    if (h && typeof h.type === "string") h.type = h.type.toLowerCase();
    if (h && Array.isArray(h.comments)) {
      for (const c of h.comments) {
        if (c && typeof c.type === "string") c.type = c.type.toLowerCase();
      }
    }
  }
  
  const matches = [];
  const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
  let node;
  
  while (node = walker.nextNode()) {
    for (const highlight of highlights) {
      const index = node.textContent.indexOf(highlight.sentence);
      if (index !== -1) {
        const range = document.createRange();
        range.setStart(node, index);
        range.setEnd(node, index + highlight.sentence.length);
        matches.push({ range: range, highlight: highlight });
      }
    }
  }
  
  matches.reverse().forEach(match => {
    const span = document.createElement('span');
    span.className = 'highlighted-text';
    span.dataset.highlightType = (match.highlight.type || "").toLowerCase();
    
    try {
      match.range.surroundContents(span);
      renderCapsules(span, match.highlight.comments);
    } catch (e) {
      console.error("하이라이트 적용 중 오류 발생:", e);
    }
  });
  
  document.addEventListener('click', (event) => {
    if (currentMemoBox && !currentMemoBox.contains(event.target) && !event.target.closest('.memo-capsule')) {
      currentMemoBox.remove();
      currentMemoBox = null;
      document.querySelectorAll('.memo-capsule.clicked-what, .memo-capsule.clicked-why, .memo-capsule.clicked-detail').forEach(c => {
        c.classList.remove('clicked-what', 'clicked-why', 'clicked-detail');
      });
    }
  });
  
  void 0;
}
