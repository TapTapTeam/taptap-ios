//
//  OnboardingHighlightGuideFeature.swift
//  Feature
//
//  Created by 여성일 on 1/13/26.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct OnboardingHighlightGuideFeature {
  @ObservableState
  public struct State: Equatable {
    var animationPhase: AnimationPhase = .onAppear
    var headerTitle: String = "문장 하이라이트"
    var pageCount: Int = 0
    var dragHandImageName: String = "OneFingerScroll"
    var dragProgress: CGFloat = 1.0
    
    // onAppear
    var visibleFirstTip: Bool = true
    
    // doubleTapGuideEvent
    var visibleSecondTip: Bool = false
    var visibleOverlay: Bool = false
    var visibleDoubleTapLottie: Bool = false
    
    // dragGuideEvent
    var visibleDragFirstTip: Bool = false
    var visibleDragSecondTip: Bool = false
    var visibleToolTip: Bool = false
    var visibleDrag: Bool = false
    var visibleDragHand: Bool = false
    
    // selectColorGuideEvent
    var visibleSelectColorFirstTip: Bool = false
    var visiblePinkChipLottie: Bool = false
    
    // tapColorEvent
    var visibleHighlight: Bool = false
    var visibleTapHighlightFirstTip: Bool = false
    
    // tapHighlightEvent
    var visibleMemoFirstTip: Bool = false
    var visibleMemoChipLottie: Bool = false
    
    // memoEvent
    var visibleMemoBox: Bool = false
    
    // finishEvent
    var visibleMemoChip: Bool = false
    
    enum AnimationPhase {
      case onAppear
      case doubleTapGuideEvent
      case doubleTapDragEvent
      case dragAnimationEvent
      case selectColorGuideEvent
      case tapColorEvent
      case tapHighlightEvent
      case memoEvent
      case finishEvent
    }
    
    public init() {}
  }
  
  public enum Action: Equatable {
    case backButtonTapped
    case nextButtonTapped
    
    case onAppear
    case doubleTapGuideEvent
    case hideDoubleTapLottie
    case doubleTapDragEvent
    case changeDragSecondTip
    case showDragHand
    case dragAnimationEvent
    case changeDragHandImage
    case selectColorGuideEvent
    case hidePinkChipLottie
    case tapColorEvent
    case tapHighlightGuideEvent
    case tapHighlightEvent
    case hideMemoChipLottie
    case memoEvent
    case finishEvent
    
    case moveToOnboardingShare
  }
  
  @Dependency(\.continuousClock) var clock
  
  enum CancelID {
    case onboarding
    case dragAnimation
    case colorAnimation
    case memoAnimation
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        guard state.animationPhase == .onAppear else {
          return .none
        }
        
        state.animationPhase = .doubleTapGuideEvent
        
        return .run { send in
          try await clock.sleep(for: .seconds(2))
          await send(.doubleTapGuideEvent)
        }
        .cancellable(id: CancelID.onboarding)
        
      case .doubleTapGuideEvent:
        guard state.animationPhase == .doubleTapGuideEvent else {
          return .none
        }
        
        state.visibleFirstTip = false
        state.visibleOverlay = true
        state.visibleSecondTip = true
        state.visibleDoubleTapLottie = true
        return .none
        
      case .hideDoubleTapLottie:
        state.animationPhase = .doubleTapDragEvent
        state.visibleDoubleTapLottie = false
        return .none
        
      case .doubleTapDragEvent:
        guard state.animationPhase == .doubleTapDragEvent else {
          return .none
        }
        
        state.visibleOverlay = false
        state.visibleSecondTip = false
        state.visibleOverlay = false
        
        state.visibleDrag = true
        state.visibleDragFirstTip = true
        state.visibleToolTip = true
        
        state.animationPhase = .dragAnimationEvent
        
        return .run { send in
          try await clock.sleep(for: .seconds(2.3))
          await send(.changeDragSecondTip)
          
          try await clock.sleep(for: .seconds(2.0))
          await send(.showDragHand)
          
          try await clock.sleep(for: .seconds(1.5))
          await send(.dragAnimationEvent)
        }
        .cancellable(id: CancelID.dragAnimation, cancelInFlight: true)
        
      case .changeDragSecondTip:
        state.visibleDragFirstTip = false
        state.visibleDragSecondTip = true
        return .none
        
      case .showDragHand:
        state.visibleDragSecondTip = false
        state.visibleDragHand = true
        return .none
        
      case .dragAnimationEvent:
        guard state.animationPhase == .dragAnimationEvent else {
          return .none
        }
        
        state.dragProgress = 0.0
        
        state.animationPhase = .selectColorGuideEvent
        
        return .run { send in
          try await clock.sleep(for: .seconds(0.5))
          await send(.changeDragHandImage)
          
          try await clock.sleep(for: .seconds(2.0))
          await send(.selectColorGuideEvent)
        }
        .cancellable(id: CancelID.colorAnimation, cancelInFlight: true)
        
      case .changeDragHandImage:
        state.dragHandImageName = "OneFinger"
        return .none
        
      case .selectColorGuideEvent:
        guard state.animationPhase == .selectColorGuideEvent else {
          return .none
        }
        
        state.visibleDragHand = false
        state.visiblePinkChipLottie = true
        state.visibleSelectColorFirstTip = true
        return .none
        
      case .hidePinkChipLottie:
        state.animationPhase = .tapColorEvent
        state.visiblePinkChipLottie = false
        state.visibleSelectColorFirstTip = false
        return .none
        
      case .tapColorEvent:
        guard state.animationPhase == .tapColorEvent else {
          return .none
        }
        
        state.visibleDrag = false
        state.visibleToolTip = false
        state.visibleHighlight = true
        
        return .run { send in
          try await clock.sleep(for: .seconds(2.0))
          await send(.tapHighlightGuideEvent)
        }
        .cancellable(id: CancelID.colorAnimation, cancelInFlight: true)
        
      case .tapHighlightGuideEvent:
        state.animationPhase = .tapHighlightEvent
        state.headerTitle = "메모 입력하기"
        state.pageCount = 1
        state.visibleTapHighlightFirstTip = true
        return .none
        
      case .tapHighlightEvent:
        guard state.animationPhase == .tapHighlightEvent else {
          return .none
        }
        
        state.visibleTapHighlightFirstTip = false
        state.visibleDrag = true
        state.visibleToolTip = true
        state.visibleMemoFirstTip = true
        state.visibleMemoChipLottie = true
        return .none
        
      case .hideMemoChipLottie:
        state.visibleMemoChipLottie = false
        state.animationPhase = .memoEvent
        return .none
        
      case .memoEvent:
        guard state.animationPhase == .memoEvent else {
          return .none
        }
        
        state.visibleDrag = false
        state.visibleToolTip = false
        state.visibleMemoFirstTip = false
        state.visibleMemoBox = true
        
        state.animationPhase = .finishEvent
        
        return .run { send in
          try await clock.sleep(for: .seconds(3.0))
          await send(.finishEvent)
        }
        .cancellable(id: CancelID.memoAnimation, cancelInFlight: true)
        
      case .finishEvent:
        guard state.animationPhase == .finishEvent else {
          return .none
        }
        
        state.visibleMemoBox = false
        state.visibleMemoChip = true
        return .none
        
        
      case .backButtonTapped:
        return .concatenate(
          .cancel(id: CancelID.onboarding),
          .cancel(id: CancelID.dragAnimation),
          .cancel(id: CancelID.colorAnimation),
          .cancel(id: CancelID.memoAnimation),
        )
        
      case .nextButtonTapped:
        return .concatenate(
          .cancel(id: CancelID.onboarding),
          .cancel(id: CancelID.dragAnimation),
          .cancel(id: CancelID.colorAnimation),
          .cancel(id: CancelID.memoAnimation),
          .send(.moveToOnboardingShare)
        )
        
      case .moveToOnboardingShare:
        return .none
      }
    }
  }
  
  public init() {}
}
