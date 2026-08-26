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
/// 로컬 모니터는 **앱 전체** 이벤트를 받으므로, 이 뷰가 올라간 창에서 온 입력만 처리합니다.
/// (`WindowGroup`이라 ⌘N으로 창을 여러 개 열 수 있고, 그때 다른 창의 Escape가
/// 이 오버레이를 닫아버리면 안 됩니다.)
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
  /// 모니터와 호스트 창은 이벤트 발생 시점에 읽어야 하므로 참조 타입에 담습니다.
  /// 값 타입 `@State`를 클로저에 캡처하면 설치 시점의 값이 굳어버립니다.
  private final class Storage {
    var monitor: Any?
    weak var hostWindow: NSWindow?
  }

  private let action: () -> Void

  @State private var storage = Storage()

  public init(action: @escaping () -> Void) {
    self.action = action
  }

  public func body(content: Content) -> some View {
    content
      .background(HostWindowReader { storage.hostWindow = $0 })
      .onAppear {
        guard storage.monitor == nil else { return }
        storage.monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [storage] event in
          guard event.keyCode == escapeKeyCode else { return event }
          // 호스트 창을 아직 못 잡았으면 남의 창 이벤트를 삼키지 않도록 흘려보낸다.
          guard let hostWindow = storage.hostWindow, event.window === hostWindow else {
            return event
          }
          action()
          return nil
        }
      }
      .onDisappear {
        guard let monitor = storage.monitor else { return }
        NSEvent.removeMonitor(monitor)
        storage.monitor = nil
      }
  }

  private var escapeKeyCode: UInt16 { 53 }
}

/// 이 뷰가 올라간 `NSWindow`를 알려주는 백그라운드 뷰입니다.
private struct HostWindowReader: NSViewRepresentable {
  let onResolve: (NSWindow?) -> Void

  func makeNSView(context: Context) -> NSView {
    let view = NSView(frame: .zero)
    // makeNSView 시점에는 아직 창에 붙기 전이라 다음 런루프에 읽는다.
    DispatchQueue.main.async { onResolve(view.window) }
    return view
  }

  func updateNSView(_ nsView: NSView, context: Context) {
    DispatchQueue.main.async { onResolve(nsView.window) }
  }
}

public extension View {
  /// Escape 키를 눌렀을 때 `action`을 실행합니다. 포커스 여부와 무관하게 동작합니다.
  func onEscape(perform action: @escaping () -> Void) -> some View {
    modifier(EscapeDismissModifier(action: action))
  }
}
#endif
