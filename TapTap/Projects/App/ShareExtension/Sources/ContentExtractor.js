var ContentExtractor = function() {};

ContentExtractor.prototype = {
  run: function(arguments) {
    let debugInfo = {};
    let highlightsJSON = "[]"; // 기본값은 빈 배열 형태의 JSON 문자열

    try {
      const sharedDiv = document.getElementById('taptap-data-for-share');
      debugInfo.divExists = !!sharedDiv;

      if (sharedDiv) {
        const savedHighlightsText = sharedDiv.textContent;
        debugInfo.rawText = savedHighlightsText;

        if (savedHighlightsText && savedHighlightsText.trim() !== '') {
          highlightsJSON = savedHighlightsText; // 객체로 변환하지 않고 문자열 그대로 사용
          debugInfo.passAsString = 'Success';
        } else {
          debugInfo.passAsString = 'Skipped: Text was empty or null.';
        }
      } else {
        debugInfo.passAsString = 'Skipped: Div not found.';
      }
    } catch (e) {
      debugInfo.passAsString = 'Error in JS';
      debugInfo.error = e.toString();
    }

    const result = {
      "title": document.title,
      "url": document.URL,
      "highlightsJSON": highlightsJSON, // highlights 객체 대신 JSON 문자열을 전달
      "imageURL": this.extractThumbnailImage(),
      "mediaCompany": this.extractMediaCompany(),
      "debugInfo": debugInfo
    };
    
    arguments.completionFunction(result);
  },
  
  extractThumbnailImage: function() {
    let imageURL = "";
    
    let ogImage = document.querySelector('meta[property="og:image"]');
    if (ogImage && ogImage.content) {
      imageURL = ogImage.content;
    }
    
    if (!imageURL) {
      let twitterImage = document.querySelector('meta[name="twitter:image"]');
      if (twitterImage && twitterImage.content) {
        imageURL = twitterImage.content;
      }
    }
    
    if (!imageURL) {
      let appleIcon = document.querySelector('link[rel="apple-touch-icon"]');
      if (appleIcon && appleIcon.href) {
        imageURL = appleIcon.href;
      }
    }
    
    if (!imageURL) {
      let favicon = document.querySelector('link[rel="icon"]');
      if (favicon && favicon.href) {
        imageURL = favicon.href;
      }
    }
    
    if (!imageURL) {
      let images = Array.from(document.querySelectorAll('img'));
      if (images.length > 0) {
        images.sort((a, b) => (b.naturalWidth * b.naturalHeight) - (a.naturalWidth * a.naturalHeight));
        if (images[0].src) {
          imageURL = images[0].src;
        }
      }
    }
    
    return imageURL;
  },
  
  extractMediaCompany: function() {
    let mediaCompany = "";
    let logoImg = document.querySelector('.media_end_head_top_logo_img.light_type');
    if (logoImg && logoImg.alt) {
      mediaCompany = logoImg.alt;
    } else {
      let logoText = document.querySelector('.media_end_head_top_logo_text.light_type');
      if (logoText && logoText.textContent) {
        mediaCompany = logoText.textContent;
      }
    }
    return mediaCompany;
  },
  
  finalize: function(arguments) {
    if (arguments.clearDrafts) {
      const draftSpans = document.querySelectorAll('.highlighted-text[data-draft-id]');
      draftSpans.forEach(span => {
        const capsuleContainer = span.nextElementSibling;
        if (capsuleContainer && capsuleContainer.classList.contains('capsule-container')) {
          capsuleContainer.remove();
        }
        span.replaceWith(...span.childNodes);
      });
      
      browser.storage.local.remove('draftHighlights').then(() => {
        console.log('Finalize: 초안 데이터가 삭제되었습니다.');
      });
    }
  }
};

var ExtensionPreprocessingJS = new ContentExtractor;
