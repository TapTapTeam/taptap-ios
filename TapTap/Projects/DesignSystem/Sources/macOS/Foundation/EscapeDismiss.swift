//
//  EscapeDismiss.swift
//  DesignSystem
//
//  Created by Hong on 8/26/26.
//

#if os(macOS)
import AppKit
import SwiftUI

/// Escape 키를 창 단위로 받아 오버레이를 닫는 수식어입니다.
///
/// SwiftUI의 `.onExitCommand`는 **포커스를 가진 뷰에만** 전달됩니다.
/// 딤 레이어 위에 얹은 팝오버·모달처럼 포커스를 갖지 않는 오버레이에서는
/// `.onExitCommand`를 붙여도 호출되지 않으므로, 여기서는 `NSEvent` 로컬 모니터로
/// keyDown을 직접 받습니다.
///
/// 모니터는 이 수식어가 붙은 뷰가 화면에 있는 동안에만 설치되므로,
/// 오버레이가 표시되는 분기 안쪽에 붙여야 합니다.
///
/// ```swift
/// if isPresented {
///   MyPopover()
///     .onEscape { isPresented = false }
/// }
/// ```
public struct EscapeDismissModifier: ViewModifier {
  private let action: () -> Void

  @State private var monitor: Any?

  public init(action: @escaping () -> Void) {
    self.action = action
  }

  public func body(content: Content) -> some View {
    content
      .onAppear {
        guard monitor == nil else { return }
        monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
          guard event.keyCode == escapeKeyCode else { return event }
          action()
          return nil
        }
      }
      .onDisappear {
        guard let monitor else { return }
        NSEvent.removeMonitor(monitor)
        self.monitor = nil
      }
  }

  private var escapeKeyCode: UInt16 { 53 }
}

public extension View {
  /// Escape 키를 눌렀을 때 `action`을 실행합니다. 포커스 여부와 무관하게 동작합니다.
  func onEscape(perform action: @escaping () -> Void) -> some View {
    modifier(EscapeDismissModifier(action: action))
  }
}
#endif
