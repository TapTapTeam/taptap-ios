//
//  AddCategoryPopover.swift
//  TapTapMac
//

import SwiftUI
#if os(macOS)
import AppKit
#endif

import DesignSystem

struct AddCategoryPopover: View {
  var title: String = "카테고리 추가하기"
  @Binding var categoryName: String
  @Binding var selectedIconNumber: Int
  let isDuplicateName: Bool
  let onClose: () -> Void
  let onSave: () -> Void
  
  @FocusState private var isNameFocused: Bool
  @State private var hoveredIconNumber: Int?
  
  private let maxNameCount = 14
  private let columns = Array(
    repeating: GridItem(.fixed(73.3), spacing: 16),
    count: 6
  )
  
  private var trimmedName: String {
    categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  private var canSave: Bool {
    !trimmedName.isEmpty && !isDuplicateName
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      header
      content
      footer
    }
    .padding(.top, 10)
    .padding(.bottom, 20)
    .frame(width: 560)
    .background(Color.background)
    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    .shadow(color: Color.black.opacity(0.10), radius: 8, x: 0, y: 0)
    .onAppear {
      isNameFocused = true
    }
  }
  
  private var header: some View {
    HStack(spacing: 12) {
      Text(title)
        .font(.B1_SB)
        .foregroundStyle(Color.text1)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Button(action: onClose) {
        Image(icon: Icon.x)
          .resizable()
          .frame(width: 20, height: 20)
          .foregroundStyle(Color.icon)
          .frame(width: 40, height: 40)
          .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
      .accessibilityLabel("닫기")
    }
    .padding(.leading, 20)
    .padding(.trailing, 10)
  }
  
  private var content: some View {
    VStack(alignment: .leading, spacing: 20) {
      nameField
      iconPicker
    }
    .padding(.vertical, 10)
  }
  
  private var nameField: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("카테고리명")
        .font(.B2_SB)
        .foregroundStyle(Color.caption1)
        .padding(.horizontal, 4)
      
      HStack(spacing: 8) {
        TextField("카테고리명을 입력해주세요", text: $categoryName)
          .textFieldStyle(.plain)
          .font(.B1_M)
          .foregroundStyle(Color.text1)
          .focused($isNameFocused)
          .onChange(of: categoryName) { _, newValue in
            if newValue.count > maxNameCount {
              categoryName = String(newValue.prefix(maxNameCount))
            }
          }
        
        HStack(spacing: 0) {
          Text("\(categoryName.count)")
            .foregroundStyle(Color.text1)
          Text("/\(maxNameCount)")
            .foregroundStyle(Color.caption2)
        }
        .font(.C2)
      }
      .padding(16)
      .frame(height: 56)
      .background(Color.n0)
      .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
      .overlay {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .strokeBorder(isDuplicateName ? Color.danger : Color.divider1, lineWidth: 1)
      }
      
      if isDuplicateName {
        Text("이미 존재하는 카테고리예요")
          .font(.C2)
          .foregroundStyle(Color.danger)
          .padding(.horizontal, 4)
      }
    }
    .padding(.horizontal, 20)
  }
  
  private var iconPicker: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("카테고리 아이콘")
        .font(.B2_SB)
        .foregroundStyle(Color.caption1)
        .padding(.horizontal, 4)
      
      ZStack(alignment: .bottom) {
        ScrollView {
          LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
            ForEach(1..<25, id: \.self) { iconNumber in
              AddCategoryIconButton(
                iconNumber: iconNumber,
                isSelected: selectedIconNumber == iconNumber,
                isHovered: hoveredIconNumber == iconNumber
              ) {
                selectedIconNumber = iconNumber
              }
              .onHover { isHovering in
                hoveredIconNumber = isHovering ? iconNumber : nil
              }
            }
          }
          .padding(.bottom, 10)
        }
        .scrollIndicators(.hidden)
        .background(HiddenScrollIndicatorsConfigurator())
        
        LinearGradient(
          colors: [
            Color.bgButtonGrad4.opacity(0),
            Color.background.opacity(0.90),
            Color.background
          ],
          startPoint: .top,
          endPoint: .bottom
        )
        .frame(height: 32)
        .allowsHitTesting(false)
      }
      .frame(height: 243)
    }
    .padding(.horizontal, 20)
  }
  
  private var footer: some View {
    HStack {
      Spacer()
      
      Button(action: onSave) {
        Text("확인")
          .font(.H4_SB)
          .foregroundStyle(canSave ? Color.textw : Color.caption2)
          .padding(.horizontal, 22)
          .frame(height: 48)
          .background(canSave ? Color.bl6 : Color.n40)
          .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
      }
      .buttonStyle(.plain)
      .disabled(!canSave)
    }
    .padding(.horizontal, 20)
  }
}

#if os(macOS)
private struct HiddenScrollIndicatorsConfigurator: NSViewRepresentable {
  func makeNSView(context: Context) -> NSView {
    let view = NSView()
    DispatchQueue.main.async {
      hideScrollIndicators(from: view)
    }
    return view
  }
  
  func updateNSView(_ nsView: NSView, context: Context) {
    DispatchQueue.main.async {
      hideScrollIndicators(from: nsView)
    }
  }
  
  private func hideScrollIndicators(from view: NSView) {
    guard let scrollView = scrollView(near: view) else { return }
    scrollView.autohidesScrollers = true
    scrollView.scrollerStyle = .overlay
    scrollView.verticalScroller?.isHidden = true
    scrollView.horizontalScroller?.isHidden = true
    scrollView.verticalScroller?.alphaValue = 0
    scrollView.horizontalScroller?.alphaValue = 0
  }
  
  private func scrollView(near view: NSView) -> NSScrollView? {
    if let enclosingScrollView = view.enclosingScrollView {
      return enclosingScrollView
    }
    
    var parent = view.superview
    while let current = parent {
      if let scrollView = current as? NSScrollView {
        return scrollView
      }
      if let scrollView = firstScrollView(in: current.subviews) {
        return scrollView
      }
      parent = current.superview
    }
    
    return firstScrollView(in: view.window?.contentView?.subviews ?? [])
  }
  
  private func firstScrollView(in views: [NSView]) -> NSScrollView? {
    for view in views {
      if let scrollView = view as? NSScrollView {
        return scrollView
      }
      if let scrollView = firstScrollView(in: view.subviews) {
        return scrollView
      }
    }
    
    return nil
  }
}
#else
private struct HiddenScrollIndicatorsConfigurator: View {
  var body: some View {
    EmptyView()
  }
}
#endif

private struct AddCategoryIconButton: View {
  let iconNumber: Int
  let isSelected: Bool
  let isHovered: Bool
  let onTap: () -> Void
  
  var body: some View {
    Button(action: onTap) {
      RoundedRectangle(cornerRadius: 10.619, style: .continuous)
        .fill(backgroundColor)
        .frame(width: 73.3, height: 73.3)
        .overlay {
          DesignSystemAsset.primaryCategoryIcon(number: iconNumber)
            .resizable()
            .frame(width: 44.245, height: 44.245)
            .opacity(0.8)
        }
        .overlay {
          RoundedRectangle(cornerRadius: 9.619, style: .continuous)
            .stroke(isSelected ? Color.bl6 : Color.clear, lineWidth: 1.25)
            .padding(1)
        }
    }
    .buttonStyle(.plain)
    .shadow(color: Color.bgShadow3, radius: 3.54, x: 0, y: 0)
    .accessibilityLabel("카테고리 아이콘 \(iconNumber)")
  }
  
  private var backgroundColor: Color {
    if isSelected {
      return Color.bl1
    }
    
    if isHovered {
      return Color.statePressedDim
    }
    
    return Color.n0
  }
}
