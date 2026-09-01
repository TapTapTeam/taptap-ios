//
//  PlatformCompat.swift
//  Shell
//
//  Created by Hong on 9/1/26.
//

import SwiftUI

#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// 셸은 macOS 앱과 iPad가 함께 쓰므로, 플랫폼마다 다른 API는 여기로 모은다.
enum Platform {
  /// 외부 브라우저로 URL을 연다.
  static func openExternalURL(_ url: URL) {
#if os(macOS)
    NSWorkspace.shared.open(url)
#else
    UIApplication.shared.open(url)
#endif
  }
}

/// 사이드바 뒤를 흐리게 깔아주는 배경 레이어.
/// macOS는 CoreImage 백그라운드 필터로 뒤 콘텐츠를 직접 블러하고,
/// iPadOS에는 같은 API가 없어 시스템 머티리얼로 대체한다.
struct SidebarBackdropBlur: View {
  var radius: CGFloat = 8

  var body: some View {
#if os(macOS)
    MacBackdropBlur(radius: radius)
#else
    Rectangle()
      .fill(.ultraThinMaterial)
      .allowsHitTesting(false)
#endif
  }
}
