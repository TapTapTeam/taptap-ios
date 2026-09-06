//
//  AnalyticsValue.swift
//  AnalyticsKit
//
//  Created by 홍 on 9/5/26.
//

import Foundation

/// 이벤트 파라미터·유저 프로퍼티에 실을 수 있는 값.
///
/// `Any`를 쓰지 않는 이유는 두 가지다.
/// 1. `Sendable`을 유지해야 리듀서의 `.run` 이펙트 안에서 그대로 넘길 수 있다.
/// 2. GA4와 Amplitude가 받는 타입이 다르다 — 여기서 한 번 좁혀두면 각 프로바이더가 변환만 하면 된다.
public enum AnalyticsValue: Equatable, Sendable {
  case string(String)
  case int(Int)
  case double(Double)
  case bool(Bool)

  /// GA4(Firebase)로 보낼 표현.
  ///
  /// Firebase 파라미터는 `NSString`·`NSNumber`만 받는다. `Bool`은 GA4 리포트에서
  /// 0/1 숫자보다 `"true"`/`"false"` 문자열이 훨씬 읽기 쉬워 문자열로 보낸다.
  var firebaseValue: Any {
    switch self {
    case .string(let value): return value
    case .int(let value): return value
    case .double(let value): return value
    case .bool(let value): return value ? "true" : "false"
    }
  }

  /// Amplitude로 보낼 표현. Amplitude는 JSON이라 `Bool`을 그대로 받는다.
  var amplitudeValue: Any {
    switch self {
    case .string(let value): return value
    case .int(let value): return value
    case .double(let value): return value
    case .bool(let value): return value
    }
  }

  /// 콘솔 로그용 표현.
  var debugDescription: String {
    switch self {
    case .string(let value): return value
    case .int(let value): return String(value)
    case .double(let value): return String(value)
    case .bool(let value): return String(value)
    }
  }
}

public extension AnalyticsValue {
  /// 자유 입력(검색어·링크 제목 등)은 그대로 보내지 않는다.
  ///
  /// 개인정보이기도 하고, GA4는 파라미터 값이 100자를 넘으면 잘라버려서
  /// "긴 검색어"와 "잘린 검색어"가 같은 값으로 뭉개진다. 길이 구간만 남긴다.
  static func lengthBucket(_ text: String) -> AnalyticsValue {
    lengthBucket(characters: text.count)
  }

  static func lengthBucket(characters: Int) -> AnalyticsValue {
    switch characters {
    case ..<0: return .string("unknown")
    case 0: return .string("0")
    case 1...5: return .string("1-5")
    case 6...15: return .string("6-15")
    case 16...40: return .string("16-40")
    default: return .string("41+")
    }
  }

  /// 개수도 원값 대신 구간으로 보낸다 — 유저 프로퍼티는 카디널리티가 낮아야 그룹핑이 된다.
  static func countBucket(_ count: Int) -> AnalyticsValue {
    switch count {
    case ..<0: return .string("unknown")
    case 0: return .string("0")
    case 1...4: return .string("1-4")
    case 5...19: return .string("5-19")
    case 20...49: return .string("20-49")
    default: return .string("50+")
    }
  }
}
