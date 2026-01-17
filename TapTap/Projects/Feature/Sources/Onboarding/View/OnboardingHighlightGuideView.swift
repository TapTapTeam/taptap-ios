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
  
  @State private var currentPage: Int = 0
  
  @State private var color: Color = .highlightWhat
  @State private var doubleTapParnassus: Bool = false
  @State private var tapPinkChip: Bool = false
  @State private var showOverlay: Bool = false
  @State private var showDrag: Bool = false
  @State private var showHighlight: Bool = false
  
  @State private var showFirstTip: Bool = true
  @State private var showSecondTip: Bool = false
  
  @State private var showFirstHighlightTip: Bool = false
  @State private var showSecondHighlightTip: Bool = false
  @State private var showThirdHighlightTip: Bool = false
  @State private var showMemoBox: Bool = false
  @State private var showMemoChip: Bool = false
  
  @State private var showFirstMemoTip: Bool = false
  @State private var showSecondMemoTip: Bool = false
  
  @State private var showOneFinger: Bool = false
  @State private var fingerImageName: String = "OneFingerScroll"
  @State private var showHighlightTip: Bool = false
  
  @State private var highlightProgress: CGFloat = 1.0
  
  public init(store: StoreOf<OnboardingHighlightGuideFeature>) {
    self.store = store
  }
}

extension OnboardingHighlightGuideView: View {
  public var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background.ignoresSafeArea()
      
      VStack(spacing: 0) {
        TopAppBarDefaultRightIconx(title: "문장 하이라이트") {
          store.send(.backButtonTapped)
        }
        OnboardingHeaderPageControl(numberOfPages: 2, currentPage: currentPage)
        
        FirstParnassusView()
          .overlay {
            Rectangle()
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(.dim)
              .opacity(showOverlay ? 0.4 : 0)
              .animation(.easeOut(duration: 0.3), value: showOverlay)
          }
        
        VStack(alignment: .leading, spacing: 6) {
          HStack(spacing: 0) {
            Text("나의 하이라이트가 쌓일수록, ")
              .overlay {
                GeometryReader { geometry in
                  if doubleTapParnassus {
                    Group {
                      if showOneFinger {
                        Image(icon: fingerImageName)
                          .resizable()
                          .frame(width: 82, height: 82)
                          .offset(x: -30, y: 16)
                          .animation(.easeInOut(duration: 0.3), value: showOneFinger)
                          .zIndex(1000)
                      }
                      
                      Rectangle()
                        .frame(width: 2)
                        .frame(height: geometry.size.height + 6)
                        .foregroundStyle(.onboardingIconColor)
                      
                      Circle()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.onboardingIconColor)
                        .offset(x: -7, y: -16) // x: -(16-2)/2 로 중앙 정렬
                    }
                    .offset(x: geometry.size.width * (1 - highlightProgress))
                    
                    if showDrag {
                      Color.highlightDrag.opacity(0.25)
                        .frame(width: geometry.size.width * highlightProgress)
                        .frame(height: geometry.size.height + 6)
                        .offset(x: geometry.size.width * (1 - highlightProgress))
                    }
                  }
                }
              }
              .zIndex(2)
            
            Text("글은 단순한 읽을거리가")
              .onTapGesture {
                onTapParnassus()
              }
              .background(showHighlight ? .highlightWhat : .clear)
              .overlay {
                GeometryReader { geo in
                  if doubleTapParnassus {
                    if showDrag {
                      Color.highlightDrag.opacity(0.25)
                        .frame(width: geo.size.width, alignment: .leading)
                        .frame(height: geo.size.height + 6, alignment: .center)
                    }
                  }
                }
              }
              .zIndex(1)
            Spacer()
          }
          .zIndex(1)
          .overlay(alignment: .top) {
            GeometryReader { geometry in
              if showFirstHighlightTip {
                OnboardingToolTipBoxBottom(text: "해당 문장이 드래그 돼요")
                  .frame(maxWidth: .infinity)
                  .offset(y: geometry.size.height - 80)
                  .animation(.easeOut(duration: 0.3), value: showFirstTip)
              }
              
              if showSecondHighlightTip {
                OnboardingToolTipBoxBottom(
                  text: "드래그를 통해 하이라이트 부분을\n수정할 수 있어요",
                  multilineTextAlignment: .center
                )
                .frame(maxWidth: .infinity)
                .offset(y: geometry.size.height - 105)
                .animation(.easeInOut(duration: 0.3), value: showFirstTip)
              }
            }
          }
          .frame(maxWidth: .infinity)
          
          Text("아니라 나만의 데이터가 됩니다.")
            .onTapGesture {
              onTapParnassus()
            }
            .background(showHighlight ? .highlightWhat : .clear)
            .overlay {
              GeometryReader { geometry in
                if doubleTapParnassus {
                  if showDrag {
                    Color.highlightDrag.opacity(0.25)
                      .frame(width: geometry.size.width, alignment: .leading)
                  }
                  
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
                
                if showHighlightTip {
                  OnboardingHighlightTip(
                    onChipTapped: onTapPinkChip,
                    onMemoTapped: onTapMemo
                  )
                  .animation(.easeInOut(duration: 0.3), value: doubleTapParnassus)
                  .offset(
                    x: (UIScreen.main.bounds.width - 20 * 2 - 226) / 2,
                    y: geometry.size.height + 20
                  )
                  .animation(.easeInOut(duration: 0.3), value: doubleTapParnassus)
                }
              }
            }
        }
        .font(.B1_M_HL)
        .foregroundStyle(.text1)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .onTapGesture(count: 2) {
          onDobuleTapParnassus()
        }
        .overlay(alignment: .top) {
          GeometryReader { geometry in
            if showFirstTip {
              OnboardingToolTipBox(text: "하이라이트 치는 방법을 배워볼게요")
                .frame(maxWidth: .infinity)
                .offset(y: geometry.size.height + 6)
                .animation(.easeInOut(duration: 0.3), value: showFirstTip)
            }
            
            if showSecondTip {
              OnboardingToolTipBox(
                text: "하이라이트 치고 싶은 부분을\n'두 번' 탭해요",
                multilineTextAlignment: .center
              )
              .frame(maxWidth: .infinity)
              .offset(y: geometry.size.height + 6)
              .animation(.easeOut(duration: 0.3), value: showFirstTip)
            }
            
            if showThirdHighlightTip {
              OnboardingToolTipBox(
                text: "색상을 선택하여\n수정된 범위를 하이라이트해요",
                multilineTextAlignment: .center
              )
              .frame(maxWidth: .infinity)
              .offset(y: geometry.size.height + 70)
              .animation(.easeOut(duration: 0.8), value: showFirstTip)
            }
            
            if showFirstMemoTip {
              OnboardingToolTipBox(
                text: "하이라이트 된 문장을 '한 번' 탭하여\n툴팁을 꺼내요",
                multilineTextAlignment: .center
              )
              .frame(maxWidth: .infinity)
              .offset(y: geometry.size.height + 6)
              .animation(.easeOut(duration: 0.8), value: showFirstTip)
            }
            
            if showSecondMemoTip {
              OnboardingToolTipBox(
                text: "'메모 아이콘'을 선택하여\n하이라이트에 메모를 남겨요",
                multilineTextAlignment: .center
              )
              .frame(maxWidth: .infinity)
              .offset(y: geometry.size.height + 70)
              .animation(.easeOut(duration: 0.8), value: showFirstTip)
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
            .padding(.top, showMemoBox ? 15 : 0)
            .padding(.top, showMemoChip ? 40 : 0)
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
              .opacity(showMemoChip ? 0 : 1)
              .overlay {
                if showMemoChip {
                  MainButton("다음") {
                    store.send(.nextButtonTapped)
                  }
                  .buttonStyle(.plain)
                }
              }
          }

        }
        .frame(maxHeight: .infinity)
        .overlay {
          Rectangle()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.dim).ignoresSafeArea()
            .opacity(showOverlay ? 0.4 : 0)
            .animation(.easeOut(duration: 0.3), value: showOverlay)
        }
      }
      
      if showMemoBox {
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
                if showMemoBox {
                  OnboardingToolTipBox(text: "원하는 메모를 입력하면")
                    .frame(maxWidth: .infinity)
                    .offset(y: geometry.size.height - 32)
                    .animation(.easeInOut(duration: 0.8), value: showFirstTip)
                }
              }
            }
          
          Spacer()
        }
        .transition(.opacity)
        .zIndex(101)
      }
      
      if showMemoChip {
        VStack(spacing: 0) {
          Spacer()
            .frame(height: 320)
          
          OnboardingMemoChip()
            .overlay {
              GeometryReader { geometry in
                if showMemoChip {
                  OnboardingToolTipBox(text: "해당 메모 하단에 메모칩이 생성돼요")
                    .frame(maxWidth: .infinity)
                    .offset(y: geometry.size.height + 6)
                    .animation(.easeInOut(duration: 0.8), value: showFirstTip)
                }
              }
            }
          Spacer()
        }
        .transition(.opacity)
        .zIndex(101)
      }
    }
    .background(Color.background)
    .toolbar(.hidden)
    .onAppear {
      onAppearance()
    }
  }
}

extension OnboardingHighlightGuideView {
  private func onAppearance() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      showOverlay = true
      showFirstTip = false
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
        showSecondTip = true
      }
    }
  }
  
  private func onDobuleTapParnassus() {
    doubleTapParnassus = true
    showDrag = true
    showOverlay = false
    showSecondTip = false
    showFirstHighlightTip = true
    showHighlightTip = true
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
      showFirstHighlightTip = false
      highlightAnimation()
    }
  }
  
  private func highlightAnimation() {
    showSecondHighlightTip = true
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      showSecondHighlightTip = false
      showOneFinger = true
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        withAnimation(.easeInOut(duration: 0.8)) {
          highlightProgress = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          fingerImageName = "OneFinger"
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showOneFinger = false
            showThirdHighlightTip = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
              showThirdHighlightTip = false
            }
          }
        }
      }
    }
  }
  
  private func onTapPinkChip() {
    tapPinkChip = true
    showHighlight = true
    showDrag = false
    showHighlightTip = false
    doubleTapParnassus = false
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      memoAnimation()
    }
  }
  
  private func memoAnimation() {
    showFirstMemoTip = true
    withAnimation(.easeInOut(duration: 0.8)) {
      self.currentPage = 1
    }
  }
  
  private func onTapParnassus() {
    showFirstMemoTip = false
    showHighlightTip = true
    doubleTapParnassus = true
    showDrag = true
    showSecondMemoTip = true
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      showSecondMemoTip = false
    }
  }
  
  private func onTapMemo() {
    showSecondMemoTip = false
    showHighlightTip = false
    doubleTapParnassus = false
    showDrag = false
    
    withAnimation(.easeInOut(duration: 0.3)) {
      showMemoBox = true
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
      withAnimation(.easeInOut(duration: 0.3)) {
        showMemoBox = false
        showMemoChip = true
      }
    }
  }
}
