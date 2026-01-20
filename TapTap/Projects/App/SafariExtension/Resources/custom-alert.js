//
//  custom-alert.js
//  TapTap
//
//  Created by Hong on 1/20/26.
//

window.TapTap = window.TapTap || {};
TapTap.customAlert = {
  overlay: null,
  confirmButton: null,
  cancelButton: null,
  onConfirmCallback: null,

  init: function() {
    // Inject CSS first
    const cssUrl = browser.runtime.getURL('custom-alert.css');
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = cssUrl;
    document.head.appendChild(link);

    // Create the alert HTML
    this.overlay = document.createElement('div');
    this.overlay.id = 'taptap-custom-alert-overlay';
    this.overlay.innerHTML = `
      <div class="taptap-alert-box">
        <p class="taptap-alert-message"></p>
        <div class="taptap-alert-buttons">
          <button class="taptap-alert-button cancel">취소</button>
          <button class="taptap-alert-button confirm">삭제</button>
        </div>
      </div>
    `;
    document.body.appendChild(this.overlay);

    // Get button elements
    this.messageElement = this.overlay.querySelector('.taptap-alert-message');
    this.confirmButton = this.overlay.querySelector('.taptap-alert-button.confirm');
    this.cancelButton = this.overlay.querySelector('.taptap-alert-button.cancel');

    // Add event listeners
    this.confirmButton.addEventListener('click', this.handleConfirm.bind(this));
    this.cancelButton.addEventListener('click', this.hide.bind(this));
    this.overlay.addEventListener('click', (e) => {
      // Hide if clicking on the overlay itself, not the box
      if (e.target === this.overlay) {
        this.hide();
      }
    });
  },

  show: function(message, onConfirm) {
    this.messageElement.textContent = message;
    this.onConfirmCallback = onConfirm;
    this.overlay.classList.add('visible');
  },

  hide: function() {
    this.overlay.classList.remove('visible');
    this.onConfirmCallback = null; // Clear callback
  },

  handleConfirm: function() {
    if (this.onConfirmCallback) {
      this.onConfirmCallback();
    }
    this.hide();
  }
};
