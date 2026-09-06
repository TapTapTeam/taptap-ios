//
//  analytics.js
//  TapTap
//

window.TapTap = window.TapTap || {};

window.TapTap.analytics = {
  track: function(event, properties) {
    try {
      browser.runtime.sendMessage({
        action: 'trackAnalytics',
        event: event,
        properties: properties || {}
      }).catch(() => {});
    } catch (error) {
      return;
    }
  },

  trackHighlightCreated: function(highlight) {
    this.track('highlight_created', {
      color: highlight.color || 'unknown',
      text_length: String((highlight.text || '').length),
      surface: 'safari_extension'
    });
  },

  trackHighlightDeleted: function() {
    this.track('highlight_deleted', { surface: 'safari_extension' });
  },

  trackMemoSaved: function(isEdit, memoText) {
    this.track('memo_saved', {
      is_edit: isEdit ? 'true' : 'false',
      text_length: String((memoText || '').length),
      surface: 'safari_extension'
    });
  },

  trackMemoDeleted: function() {
    this.track('memo_deleted', { surface: 'safari_extension' });
  },

  trackHighlightSynced: function(count) {
    this.track('highlight_synced', {
      count: String(count),
      surface: 'safari_extension'
    });
  }
};
