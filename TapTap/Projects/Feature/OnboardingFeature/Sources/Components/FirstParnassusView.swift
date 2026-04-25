//
//  FirstParnassusView.swift
//  Feature
//
//  Created by 여성일 on 1/13/26.
//

import SwiftUI

import DesignSystem

struct FirstParnassusView {
  
}

extension FirstParnassusView: View {
  var body: some View {
    ZStack(alignment: .top) {
      VStack(alignment: .leading, spacing: 0) {
        Rectangle()
          .frame(height: 24)
          .padding(.bottom, 8)
          .foregroundStyle(.n40)
        
        Rectangle()
          .frame(height: 24)
          .padding(.trailing, 111)
          .padding(.bottom, 48)
          .foregroundStyle(.n40)
        
        Group {
          Text("스크롤을 멈추고 눈에 들어온 한 문장을 표시하는, 그")
          Text("작은 행동이 정보를 지식으로 바꾸는 시작점이 됩니다.")
        }
        .font(.B1_M_HL)
        .foregroundStyle(.text1)
      }
      .padding(.top, 30)
      .padding(.horizontal, 20)
    }
  }
}
