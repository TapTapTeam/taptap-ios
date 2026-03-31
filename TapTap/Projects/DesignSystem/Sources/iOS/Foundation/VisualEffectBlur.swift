//
//  VisualEffectBlur.swift
//  DesignSystem
//
//  Created by 홍 on 10/22/25.
//
#if os(iOS)
import SwiftUI
import UIKit

struct VisualEffectBlur: UIViewRepresentable {
  var blurStyle: UIBlurEffect.Style
  
  func makeUIView(context: Context) -> UIVisualEffectView {
    UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
  }
  
  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
#endif
