//
//  LottieWrapperView.swift
//  DesignSystem
//
//  Created by 여성일 on 11/17/25.
//

import SwiftUI
import UIKit

import Lottie

/// Lottie 래퍼 뷰
///
/// SwiftUI에서 Lottie를 사용하기 위한 커스텀 래퍼 뷰
///
/// - Parameters:
///   - animationName: Lottie JSON 파일 이름
///   - loopMode: loopMode 값 - 기본값 '.playOnce'
///   - loopCount: 반복 재생 시 원하는 반복 값 - 기본값'nil'
///   - loopInterval: 반복 재생 시 애니메이션 실행 간격 - 기본값 'nil'
///   - bundle: Lottie JSON 파일이 포함된 번들 - 기본값 '.main'
///   - onComplete: Lottie 애니메이션 종료 시 클로저
public struct LottieWrapperView: UIViewRepresentable {
  let animationName: String
  let loopMode: LottieLoopMode
  let loopCount: Int?
  let loopInterval: TimeInterval?
  let bundle: Bundle
  let onComplete: (() -> Void)?
  
  public init(
    animationName: String,
    loopMode: LottieLoopMode = .playOnce,
    loopCount: Int? = nil,
    loopInterval: TimeInterval? = nil,
    bundle: Bundle = .main,
    onComplete: (() -> Void)? = nil
  ) {
    self.animationName = animationName
    self.loopMode = loopMode
    self.loopCount = loopCount
    self.loopInterval = loopInterval
    self.bundle = bundle
    self.onComplete = onComplete
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(
      loopMode: loopMode,
      loopCount: loopCount,
      loopInterval: loopInterval,
      onComplete: onComplete
    )
  }
  
  public func makeUIView(context: Context) -> UIView {
    let view = UIView(frame: .zero)
    
    let animationView = LottieAnimationView(name: animationName, bundle: bundle)
    
    animationView.contentMode = .scaleAspectFit
    animationView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(animationView)
    
    NSLayoutConstraint.activate([
      animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
      animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
    ])
    
    context.coordinator.animationView = animationView
    context.coordinator.startAnimation()
    
    return view
  }
  
  public func updateUIView(_ uiView: UIView, context: Context) {}
  
  public class Coordinator {
    weak var animationView: LottieAnimationView?
    let loopMode: LottieLoopMode
    let loopCount: Int?
    let loopInterval: TimeInterval?
    let onComplete: (() -> Void)?
    
    private var currentCount = 0
    private var workItem: DispatchWorkItem?
    
    init(
      loopMode: LottieLoopMode,
      loopCount: Int?,
      loopInterval: TimeInterval?,
      onComplete: (() -> Void)?
    ) {
      self.loopMode = loopMode
      self.loopCount = loopCount
      self.loopInterval = loopInterval
      self.onComplete = onComplete
    }
    
    func startAnimation() {
      guard let animationView = animationView else { return }
      
      if let count = loopCount {
        animationView.loopMode = .playOnce
        playWithCount()
      }
      else if let interval = loopInterval, loopMode == .loop {
        animationView.loopMode = .playOnce
        playWithInterval()
      }

      else {
        animationView.loopMode = loopMode
        animationView.play { [weak self] finished in
          if finished {
            DispatchQueue.main.async {
              self?.onComplete?()
            }
          }
        }
      }
    }

    private func playWithCount() {
      guard let animationView = animationView,
            let loopCount = loopCount else { return }
      
      animationView.play { [weak self] finished in
        guard let self = self, finished else { return }
        
        self.currentCount += 1
        
        if self.currentCount < loopCount {
          if let interval = self.loopInterval {
            self.workItem?.cancel()
            
            let work = DispatchWorkItem { [weak self] in
              self?.playWithCount()
            }
            self.workItem = work
            
            DispatchQueue.main.asyncAfter(
              deadline: .now() + interval,
              execute: work
            )
          } else {
            self.playWithCount()
          }
        } else {
          DispatchQueue.main.async {
            self.onComplete?()
          }
        }
      }
    }
    
    private func playWithInterval() {
      guard let animationView = animationView,
            let interval = loopInterval else { return }
      
      animationView.play { [weak self] finished in
        guard finished, let self = self else { return }
        
        self.workItem?.cancel()
        
        let work = DispatchWorkItem { [weak self] in
          self?.playWithInterval()
        }
        self.workItem = work
        
        DispatchQueue.main.asyncAfter(
          deadline: .now() + interval,
          execute: work
        )
      }
    }
    
    deinit {
      workItem?.cancel()
    }
  }
}
