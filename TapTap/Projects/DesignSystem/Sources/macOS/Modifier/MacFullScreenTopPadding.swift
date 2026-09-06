//
//  MacFullScreenTopPadding.swift
//  DesignSystem
//

#if os(macOS)

import AppKit
import SwiftUI

public struct MacFullScreenReader: NSViewRepresentable {
  private let onChange: (Bool) -> Void

  public init(onChange: @escaping (Bool) -> Void) {
    self.onChange = onChange
  }

  public func makeNSView(context: Context) -> NSView {
    let view = NSView()
    context.coordinator.onChange = onChange
    DispatchQueue.main.async {
      context.coordinator.attach(to: view)
    }
    return view
  }

  public func updateNSView(_ nsView: NSView, context: Context) {
    context.coordinator.onChange = onChange
    if context.coordinator.window == nil {
      DispatchQueue.main.async {
        context.coordinator.attach(to: nsView)
      }
    }
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  public final class Coordinator {
    var onChange: ((Bool) -> Void)?
    private(set) var window: NSWindow?
    private var observers: [NSObjectProtocol] = []

    func attach(to view: NSView) {
      guard window == nil, let window = view.window else { return }
      self.window = window
      onChange?(window.styleMask.contains(.fullScreen))

      let center = NotificationCenter.default
      observers.append(
        center.addObserver(
          forName: NSWindow.didEnterFullScreenNotification,
          object: window,
          queue: .main
        ) { [weak self] _ in
          self?.onChange?(true)
        }
      )
      observers.append(
        center.addObserver(
          forName: NSWindow.didExitFullScreenNotification,
          object: window,
          queue: .main
        ) { [weak self] _ in
          self?.onChange?(false)
        }
      )
    }

    deinit {
      observers.forEach(NotificationCenter.default.removeObserver)
    }
  }
}

public struct MacFullScreenTopPadding: ViewModifier {
  private let height: CGFloat

  @State private var isFullScreen: Bool = false

  public init(height: CGFloat) {
    self.height = height
  }

  public func body(content: Content) -> some View {
    content
      .padding(.top, isFullScreen ? height : 0)
      .background(alignment: .top) {
        MacFullScreenReader { isFullScreen = $0 }
          .frame(width: 0, height: 0)
      }
  }
}

public extension View {
  func macFullScreenTopPadding(_ height: CGFloat = 28) -> some View {
    modifier(MacFullScreenTopPadding(height: height))
  }
}

#endif
