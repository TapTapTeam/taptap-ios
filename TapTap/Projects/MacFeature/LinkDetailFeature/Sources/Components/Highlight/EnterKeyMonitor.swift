//
//  EnterKeyMonitor.swift
//  MacLinkDetailFeature
//
//  Created by 이승진 on 5/27/26.
//

import SwiftUI
import AppKit

/// SwiftUI TextEditor에서 Shift 없는 Enter 입력을 저장 액션으로 연결하기 위한 AppKit 브릿지입니다.
struct EnterKeyMonitor: NSViewRepresentable {
  let isEnabled: Bool
  let onEnter: () -> Void

  func makeNSView(context: Context) -> NSView {
    context.coordinator.onEnter = onEnter
    context.coordinator.isEnabled = isEnabled
    context.coordinator.startMonitoring()
    return NSView()
  }

  func updateNSView(_ nsView: NSView, context: Context) {
    context.coordinator.onEnter = onEnter
    context.coordinator.isEnabled = isEnabled
  }

  static func dismantleNSView(_ nsView: NSView, coordinator: Coordinator) {
    coordinator.stopMonitoring()
  }

  func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  final class Coordinator {
    var isEnabled: Bool = false
    var onEnter: (() -> Void)?
    private var monitor: Any?

    func startMonitoring() {
      guard monitor == nil else { return }

      monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
        guard let self, isEnabled else { return event }

        let isReturn = event.keyCode == 36
        let isKeypadEnter = event.keyCode == 76
        let isShiftPressed = event.modifierFlags.contains(.shift)

        guard (isReturn || isKeypadEnter), !isShiftPressed else {
          return event
        }

        onEnter?()
        return nil
      }
    }

    func stopMonitoring() {
      if let monitor {
        NSEvent.removeMonitor(monitor)
        self.monitor = nil
      }
    }
  }
}
