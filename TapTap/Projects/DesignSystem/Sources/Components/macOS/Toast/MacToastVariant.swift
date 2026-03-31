//
//  MacToastVariant.swift
//  DesignSystem
//
//  Created by 여성일 on 3/29/26.
//

/// 토스트의 시각적 스타일을 정의하는 enum입니다.
///
/// `MacToast`에서 사용되며,
/// 아이콘, 강조 색상, 배경색, 액션 버튼 스타일을 결정합니다.
///
/// - primary: 기본 안내나 성공/완료 피드백에 사용하는 스타일입니다.
/// - danger: 위험한 작업 결과를 알릴 때 사용하는 스타일입니다.
///
public enum MacToastVariant {
  case primary
  case danger
}
