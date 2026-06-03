//
//  HighlightPopupTarget.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/27/26.
//

/// 하이라이트 팝업이 어느 항목에 붙어 있는지 식별합니다.
enum HighlightPopupTarget: Hashable {
  case highlight(String)
  case comment(highlightID: String, commentID: Double)
}
