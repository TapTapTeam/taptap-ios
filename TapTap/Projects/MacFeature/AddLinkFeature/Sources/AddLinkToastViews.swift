//
//  AddLinkToastViews.swift
//  MacAddLinkFeature
//
//  Created by 홍 on 05/31/26.
//

import SwiftUI

import DesignSystem

struct AddLinkToastLayer: View {
  let isDuplicateLinkToastPresented: Bool
  let statusMessage: String?
  let isStatusError: Bool
  let onShowExistingLink: () -> Void
  let onCloseDuplicateToast: () -> Void
  let onCloseStatusToast: () -> Void
  
  var body: some View {
    ZStack(alignment: .top) {
      if isDuplicateLinkToastPresented {
        DuplicateLinkToast(
          onShowLink: onShowExistingLink,
          onClose: onCloseDuplicateToast
        )
        .frame(maxWidth: 560)
        .padding(.horizontal, 20)
        .padding(.top, 60)
        .zIndex(1)
      }
      
      if let statusMessage, isStatusError {
        LinkLoadFailedToast(
          message: statusMessage,
          onClose: onCloseStatusToast
        )
        .frame(maxWidth: 560)
        .padding(.horizontal, 20)
        .padding(.top, 60)
        .zIndex(1)
      }
    }
  }
}

private struct LinkLoadFailedToast: View {
  let message: String
  let onClose: () -> Void
  
  var body: some View {
    HStack(spacing: 12) {
      Text(message)
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(Color.text1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 8)
        .padding(.vertical, 15)
      
      AddLinkToastCloseButton {
        onClose()
      }
    }
    .padding(.horizontal, 16)
    .background {
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .fill(Color.n0)
        .overlay {
          RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color.danger.opacity(0.12))
        }
    }
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .strokeBorder(Color.danger, lineWidth: 1.5)
    }
    .shadow(color: Color.bgShadow5, radius: 8, x: 0, y: 0)
    .shadow(color: Color.bgShadow5, radius: 4, x: 0, y: 2)
  }
}

private struct DuplicateLinkToast: View {
  let onShowLink: () -> Void
  let onClose: () -> Void
  
  var body: some View {
    HStack(spacing: 12) {
      Text("이미 저장된 링크예요")
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(Color.text1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 8)
      
      Button {
        onShowLink()
      } label: {
        Text("보러가기")
          .font(.system(size: 14, weight: .semibold))
          .foregroundStyle(Color.bl7)
          .padding(.horizontal, 16)
          .frame(height: 40)
          .macHoverBackground(cornerRadius: 10, style: .continuous, normal: .clear, hovered: .n0)
      }
      .buttonStyle(.plain)
      
      AddLinkToastCloseButton {
        onClose()
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
    .background(Color.bl1)
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .strokeBorder(Color.bl6, lineWidth: 1.5)
    }
    .shadow(color: Color.bgShadow5, radius: 8, x: 0, y: 0)
    .shadow(color: Color.bgShadow5, radius: 4, x: 0, y: 2)
  }
}

private struct AddLinkToastCloseButton: View {
  let onTap: () -> Void
  
  var body: some View {
    Button(action: onTap) {
      Image(icon: Icon.x)
        .resizable()
        .frame(width: 24, height: 24)
        .foregroundStyle(Color.icon)
        .frame(width: 40, height: 40)
        .macHoverBackground(cornerRadius: 8, style: .continuous, normal: .clear, hovered: .n0)
    }
    .buttonStyle(.plain)
  }
}
