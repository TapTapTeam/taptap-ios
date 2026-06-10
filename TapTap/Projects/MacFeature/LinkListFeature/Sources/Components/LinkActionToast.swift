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
  let title: String?
  let duration: TimeInterval
  let onUndoTap: (() -> Void)?
  let onCloseTap: () -> Void
  
  @State private var progress: CGFloat = 1
  
  var body: some View {
    HStack(spacing: 0) {
      Text(message)
        .font(.H4_SB)
        .foregroundStyle(.text1)
        .lineLimit(1)
        .truncationMode(.tail)
        .padding(.leading, 36)
      
      Spacer(minLength: 16)

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
    .background(progressBackground)
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
      if count == 1, let title {
        return "링크를 \(title)\(roPostposition(for: title)) 이동했어요"
      }
      return "\(count)개의 링크를 이동했어요"
    case .delete:
      if count == 1, let title {
        return "'\(title)'을 삭제했어요"
      }
      return "\(count)개의 링크를 삭제했어요"
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

  var progressBackground: some View {
    GeometryReader { proxy in
      ZStack(alignment: .leading) {
        Color.n0

        Rectangle()
          .fill(backgroundColor)
          .frame(width: proxy.size.width * progress)
      }
    }
  }

  func roPostposition(for text: String) -> String {
    guard let scalar = text.unicodeScalars.last else { return "으로" }
    let value = scalar.value
    guard (0xAC00...0xD7A3).contains(value) else { return "으로" }

    let jongseongIndex = (value - 0xAC00) % 28
    return jongseongIndex == 0 || jongseongIndex == 8 ? "로" : "으로"
  }
}

#Preview {
  VStack(spacing: 16) {
    LinkActionToast(
      variant: .move,
      count: 3,
      title: nil,
      duration: 3,
      onUndoTap: {},
      onCloseTap: {}
    )
    
    LinkActionToast(
      variant: .delete,
      count: 3,
      title: nil,
      duration: 3,
      onUndoTap: nil,
      onCloseTap: {}
    )
  }
  .padding()
}
