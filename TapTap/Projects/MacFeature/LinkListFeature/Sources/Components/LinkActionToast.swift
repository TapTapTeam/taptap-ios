//
//  LinkActionToast.swift
//  MacLinkListFeature
//
//  Created by 이승진 on 4/28/26.
//

import SwiftUI

import DesignSystem

/// 링크 이동/삭제 완료 후 사용자 액션을 안내하는 토스트입니다.
struct LinkActionToast: View {
  enum Variant {
    case move
    case delete
  }
  
  let variant: Variant
  let count: Int
  let duration: TimeInterval
  let onUndoTap: (() -> Void)?
  let onCloseTap: () -> Void
  
  @State private var progress: CGFloat = 1
  
  var body: some View {
    HStack(spacing: 0) {
      Image(icon: icon)
        .resizable()
        .renderingMode(.template)
        .foregroundStyle(tintColor)
        .frame(width: 28, height: 28)
        .padding(.leading, 24)
        .padding(.trailing, 18)
      
      Text(message)
        .font(.H4_SB)
        .foregroundStyle(.text1)
      
      Spacer(minLength: 16)
      
      progressBar
        .padding(.trailing, onUndoTap == nil ? 18 : 14)
      
      if let onUndoTap {
        Button {
          onUndoTap()
        } label: {
          Text("실행 취소")
            .font(.H4_SB)
            .foregroundStyle(tintColor)
            .padding(.horizontal, 12)
            .frame(height: 40)
        }
        .buttonStyle(.plain)
      }
      
      Button {
        onCloseTap()
      } label: {
        DesignSystemAsset.x.swiftUIImage
          .resizable()
          .renderingMode(.template)
          .foregroundStyle(.text1)
          .frame(width: 24, height: 24)
          .frame(width: 44, height: 44)
      }
      .buttonStyle(.plain)
      .padding(.leading, 12)
      .padding(.trailing, 18)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 72)
    .background(backgroundColor)
    .clipShape(RoundedRectangle(cornerRadius: 14))
    .overlay {
      RoundedRectangle(cornerRadius: 14)
        .strokeBorder(tintColor, lineWidth: 1.5)
    }
    .shadow(color: .bgShadow3, radius: 8, x: 0, y: 0)
    .onAppear {
      progress = 1
      withAnimation(.linear(duration: duration)) {
        progress = 0
      }
    }
  }
}

private extension LinkActionToast {
  var message: String {
    switch variant {
    case .move:
      return count == 1 ? "링크를 이동했어요" : "\(count)개의 링크를 이동했어요"
    case .delete:
      return count == 1 ? "링크를 삭제했어요" : "\(count)개의 링크를 삭제했어요"
    }
  }
  
  var icon: String {
    switch variant {
    case .move:
      return Icon.badgeCheck
    case .delete:
      return Icon.alertCircle
    }
  }
  
  var tintColor: Color {
    switch variant {
    case .move:
      return .bl6
    case .delete:
      return .danger
    }
  }
  
  var backgroundColor: Color {
    switch variant {
    case .move:
      return .bl1
    case .delete:
      return .danger.opacity(0.12)
    }
  }
  
  var progressBar: some View {
    GeometryReader { proxy in
      ZStack(alignment: .leading) {
        Capsule()
          .fill(tintColor.opacity(0.16))
        
        Capsule()
          .fill(tintColor)
          .frame(width: proxy.size.width * progress)
      }
    }
    .frame(width: 180, height: 4)
  }
}

#Preview {
  VStack(spacing: 16) {
    LinkActionToast(
      variant: .move,
      count: 3,
      duration: 3,
      onUndoTap: {},
      onCloseTap: {}
    )
    
    LinkActionToast(
      variant: .delete,
      count: 3,
      duration: 3,
      onUndoTap: nil,
      onCloseTap: {}
    )
  }
  .padding()
}
