//
//  OnboardingHighlightGuideView.swift
//  Feature
//
//  Created by 여성일 on 1/13/26.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

public struct OnboardingHighlightGuideView {
  public let store: StoreOf<OnboardingHighlightGuideFeature>
  
  public init(store: StoreOf<OnboardingHighlightGuideFeature>) {
    self.store = store
  }
}

extension OnboardingHighlightGuideView: View {
  public var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background.ignoresSafeArea()
      
      VStack(spacing: 0) {
        TopAppBarDefaultRightIconx(title: store.state.headerTitle) {
          store.send(.backButtonTapped)
        }
        OnboardingHeaderPageControl(numberOfPages: 2, currentPage: store.state.pageCount)
        
        FirstParnassusView()
          .overlay {
            if store.state.visibleOverlay {
              Color.dim
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.easeOut(duration: 0.3), value: store.state.visibleOverlay)
            }
          }
        
        VStack(alignment: .leading, spacing: 6) {
          HStack(spacing: 0) {
            Text("나의 하이라이트가 쌓일수록, ")
              .overlay {
                GeometryReader { geometry in
                  if store.state.visibleDrag {
                    Group {
                      if store.state.visibleDragHand {
                        Image(icon: store.state.dragHandImageName)
                          .resizable()
                          .frame(width: 82, height: 82)
                          .offset(x: -30, y: 16)
                          .animation(.easeInOut(duration: 0.3), value: store.state.visibleDragHand)
                          .zIndex(1000)
                      }
                      
                      Rectangle()
                        .frame(width: 2)
                        .frame(height: geometry.size.height + 6)
                        .foregroundStyle(.onboardingIconColor)
                      
                      Circle()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.onboardingIconColor)
                        .offset(x: -7, y: -16)
                    }
                    .offset(x: geometry.size.width * (1 - store.state.dragProgress))
                    .animation(.easeInOut(duration: 0.8), value: store.state.dragProgress)
                    
                    Color.highlightDrag
                      .frame(width: geometry.size.width * store.state.dragProgress)
                      .frame(height: geometry.size.height + 6)
                      .offset(x: geometry.size.width * (1 - store.state.dragProgress))
                      .animation(.easeInOut(duration: 0.8), value: store.state.dragProgress)
                  }
                }
              }
              .zIndex(2)
            
            Text("글은 단순한 읽을거리가")
              .onTapGesture {
                store.send(.tapHighlightEvent)
              }
              .background(store.state.visibleHighlight ? .highlightWhat : .clear)
              .overlay {
                GeometryReader { geo in
                  if store.state.visibleDrag {
                    Color.highlightDrag
                      .frame(width: geo.size.width, alignment: .leading)
                      .frame(height: geo.size.height + 6, alignment: .center)
                  }
                }
              }
              .zIndex(1)
            Spacer()
          }
          .zIndex(1)
          .overlay(alignment: .top) {
            GeometryReader { geometry in
              if store.state.visibleDragFirstTip {
                OnboardingToolTipBoxBottom(text: "해당 문장이 드래그 돼요")
                  .frame(maxWidth: .infinity)
                  .offset(y: geometry.size.height - 80)
                  .animation(.easeOut(duration: 0.3), value: store.state.visibleDragFirstTip)
              }
              
              if store.state.visibleDragSecondTip {
                OnboardingToolTipBoxBottom(
                  text: "드래그를 통해 하이라이트 부분을\n수정할 수 있어요",
                  multilineTextAlignment: .center
                )
                .frame(maxWidth: .infinity)
                .offset(y: geometry.size.height - 105)
                .animation(.easeInOut(duration: 0.3), value: store.state.visibleDragSecondTip)
              }
            }
          }
          .frame(maxWidth: .infinity)
          
          Text("아니라 나만의 데이터가 됩니다.")
            .onTapGesture {
              store.send(.tapHighlightEvent)
            }
            .background(store.state.visibleHighlight ? .highlightWhat : .clear)
            .overlay {
              GeometryReader { geometry in
                if store.state.visibleDrag {
                  Color.highlightDrag
                    .frame(width: geometry.size.width, alignment: .leading)
                  
                  Group {
                    Rectangle()
                      .frame(width: 2)
                      .frame(height: geometry.size.height + 4)
                      .foregroundStyle(.onboardingIconColor)
                      .zIndex(100)
                    
                    Circle()
                      .frame(width: 16, height: 16)
                      .foregroundStyle(.onboardingIconColor)
                      .offset(x: -7, y: 20)
                      .zIndex(100)
                  }
                  .offset(x: geometry.size.width)
                }
                
                if store.state.visibleToolTip {
                  OnboardingHighlightTip(
                    visiblePinkChipLottie: store.state.visiblePinkChipLottie,
                    visibleMemoChipLottie: store.state.visibleMemoChipLottie,
                    onChipTapped: { store.send(.tapColorEvent) },
                    onMemoTapped: { store.send(.memoEvent) },
                    onPinkChipLottieCompleted: { store.send(.hidePinkChipLottie) },
                    onMemoChipLottieCompleted: { store.send(.hideMemoChipLottie) },
                  )
                  .animation(.easeInOut(duration: 0.3), value: store.state.visibleToolTip)
                  .offset(
                    x: (UIScreen.main.bounds.width - 20 * 2 - 226) / 2,
                    y: geometry.size.height + 20
                  )
                }
              }
            }
        }
        .font(.B1_M_HL)
        .foregroundStyle(.text1)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .onTapGesture(count: 2) {
          store.send(.doubleTapDragEvent)
        }
        .overlay(alignment: .top) {
          GeometryReader { geometry in
            if store.state.visibleFirstTip {
              OnboardingToolTipBox(text: "하이라이트 치는 방법을 배워볼게요")
                .frame(maxWidth: .infinity)
                .offset(y: geometry.size.height + 6)
                .animation(.easeInOut(duration: 0.3), value: store.state.visibleFirstTip)
            }
            
            if store.state.visibleSecondTip {
              OnboardingToolTipBox(
                text: "하이라이트 치고 싶은 부분을\n'두 번' 탭해요",
                multilineTextAlignment: .center
              )
              .frame(maxWidth: .infinity)
              .offset(y: geometry.size.height + 6)
              .animation(.easeOut(duration: 0.3), value: store.state.visibleSecondTip)
            }
            
            if store.state.visibleDoubleTapLottie {
              LottieWrapperView(
                animationName: "DoubleTap",
                bundle: .module,
                onComplete: {
                  store.send(.hideDoubleTapLottie)
                })
              .frame(width: 110, height: 110)
              .foregroundStyle(.red)
              .offset(
                x: (geometry.size.width - 110) / 2,
                y: (geometry.size.height - 110) / 2
              )
            }
            
            if store.state.visibleSelectColorFirstTip {
              OnboardingToolTipBox(
                text: "색상을 선택하여\n수정된 범위를 하이라이트해요",
                multilineTextAlignment: .center
              )
              .frame(maxWidth: .infinity)
              .offset(y: geometry.size.height + 70)
              .animation(.easeOut(duration: 0.8), value: store.state.visibleSelectColorFirstTip)
            }
            
            if store.state.visibleTapHighlightFirstTip {
              OnboardingToolTipBox(
                text: "하이라이트 된 문장을 '한 번' 탭하여\n툴팁을 꺼내요",
                multilineTextAlignment: .center
              )
              .frame(maxWidth: .infinity)
              .offset(y: geometry.size.height + 6)
              .animation(.easeOut(duration: 0.8), value: store.state.visibleTapHighlightFirstTip)
            }
            
            if store.state.visibleMemoFirstTip {
              OnboardingToolTipBox(
                text: "'메모 아이콘'을 선택하여\n하이라이트에 메모를 남겨요",
                multilineTextAlignment: .center
              )
              .frame(maxWidth: .infinity)
              .offset(y: geometry.size.height + 70)
              .animation(.easeOut(duration: 0.8), value: store.state.visibleMemoFirstTip)
            }
          }
        }
        .zIndex(100)
        
        ZStack(alignment: .top) {
          VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 0) {
              VStack(alignment: .leading, spacing: 10) {
                Rectangle()
                  .frame(height: 16)
                  .foregroundStyle(.n40)
                
                Rectangle()
                  .frame(height: 16)
                  .foregroundStyle(.n40)
                
                Rectangle()
                  .frame(height: 16)
                  .foregroundStyle(.n40)
                  .padding(.trailing, 240)
              }
              .padding(.horizontal, 20)
              .padding(.bottom, 45)
              
              VStack(alignment: .leading, spacing: 10) {
                Rectangle()
                  .frame(height: 16)
                  .foregroundStyle(.n40)
                
                Rectangle()
                  .frame(height: 16)
                  .foregroundStyle(.n40)
                
                Rectangle()
                  .frame(height: 16)
                  .foregroundStyle(.n40)
                
                Rectangle()
                  .frame(height: 16)
                  .foregroundStyle(.n40)
                  .padding(.trailing, 92)
              }
              .padding(.horizontal, 20)
              .padding(.bottom, 40)
              
              VStack(alignment: .leading, spacing: 10) {
                Rectangle()
                  .frame(height: 16)
                  .foregroundStyle(.n40)
                
                Rectangle()
                  .frame(height: 16)
                  .foregroundStyle(.n40)
                
                Rectangle()
                  .frame(height: 16)
                  .foregroundStyle(.n40)
                
                Rectangle()
                  .frame(height: 16)
                  .foregroundStyle(.n40)
                  .padding(.trailing, 198)
              }
              .padding(.horizontal, 20)
            }
            .padding(.top, store.state.visibleMemoBox  ? 15 : 0)
            .padding(.top, store.state.visibleMemoChip ? 40 : 0)
          }
          .padding(.top, 24)
          
          VStack {
            Spacer()
            DesignSystemAsset.toolbarBottom.swiftUIImage
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(maxWidth: .infinity)
              .frame(height: 68)
              .padding(.bottom, -20)
              .opacity(store.state.visibleMemoChip ? 0 : 1)
              .overlay {
                if store.state.visibleMemoChip {
                  MainButton("완료") {
                    store.send(.nextButtonTapped)
                  }
                  .buttonStyle(.plain)
                }
              }
          }
          
        }
        .frame(maxHeight: .infinity)
        .overlay {
          if store.state.visibleOverlay {
            Color.dim
              .ignoresSafeArea()
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .animation(.easeOut(duration: 0.3), value: store.state.visibleOverlay)
          }
        }
      }
      
      if store.state.visibleMemoBox {
        VStack(spacing: 0) {
          Spacer()
            .frame(height: 320)
          
          Text("하이라이트 문장을 읽고 중요한 것들에 대한 메모\n를 동시에 남겨요.")
            .font(.B1_M_HL)
            .foregroundStyle(.text1)
            .multilineTextAlignment(.leading)
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 20, trailing: 8))
            .frame(maxWidth: .infinity, maxHeight: 113, alignment: .topLeading)
            .background(.n20)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 20)
            .overlay {
              GeometryReader { geometry in
                if store.state.visibleMemoBox {
                  OnboardingToolTipBox(text: "원하는 메모를 입력하면")
                    .frame(maxWidth: .infinity)
                    .offset(y: geometry.size.height - 32)
                    .animation(.easeInOut(duration: 0.8), value: store.state.visibleMemoBox)
                }
              }
            }
          
          Spacer()
        }
        .transition(.opacity)
        .zIndex(101)
      }
      
      if store.state.visibleMemoChip {
        VStack(spacing: 0) {
          Spacer()
            .frame(height: 320)
          
          OnboardingMemoChip()
            .overlay {
              GeometryReader { geometry in
                if store.state.visibleMemoChip {
                  OnboardingToolTipBox(text: "해당 메모 하단에 메모칩이 생성돼요")
                    .frame(maxWidth: .infinity)
                    .offset(y: geometry.size.height + 6)
                    .animation(.easeInOut(duration: 0.8), value: store.state.visibleMemoChip)
                }
              }
            }
          Spacer()
        }
        .transition(.opacity)
        .zIndex(101)
      }
    }
    .animation(.easeInOut(duration: 0.3), value: store.state.visibleMemoBox)
    .animation(.easeInOut(duration: 0.3), value: store.state.visibleMemoChip)
    .background(Color.background)
    .toolbar(.hidden)
    .onAppear {
      store.send(.onAppear)
    }
  }
}
