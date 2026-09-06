//
//  AnalyticsEventTests.swift
//  AnalyticsKitTests
//
//  Created by 홍 on 9/5/26.
//

import XCTest

@testable import AnalyticsKit

/// 계측 코드의 진짜 위험은 크래시가 아니라 **오타**다.
/// 이름이 하나 어긋나면 리포트에서 이벤트가 조용히 둘로 갈리고, 몇 주 뒤에야 알게 된다.
/// 그래서 이름과 파라미터 키를 여기에 박아둔다.
final class AnalyticsEventTests: XCTestCase {
  func test_전환이벤트_이름이_고정되어_있다() {
    XCTAssertEqual(ConversionEvent.onboardingCompleted.event.name, "onboarding_complete")
    XCTAssertEqual(ConversionEvent.linkSaved(source: .app, hasCategory: true).event.name, "link_save")
    XCTAssertEqual(ConversionEvent.linkOpened(source: .search).event.name, "link_open")
    XCTAssertEqual(ConversionEvent.linkDeleted(count: 1).event.name, "link_delete")
    XCTAssertEqual(ConversionEvent.highlightCreated.event.name, "highlight_create")
    XCTAssertEqual(ConversionEvent.memoSaved(isEdit: false).event.name, "memo_save")
    XCTAssertEqual(ConversionEvent.categoryCreated(totalCount: 3).event.name, "category_create")
    XCTAssertEqual(ConversionEvent.linkMovedToCategory(count: 2).event.name, "link_move_category")
    XCTAssertEqual(
      ConversionEvent.searchSubmitted(queryLength: 3, resultCount: 0).event.name,
      "search_submit"
    )
  }

  func test_링크저장_파라미터() {
    let event = ConversionEvent.linkSaved(source: .safariExtension, hasCategory: false).event

    XCTAssertEqual(event.parameters["link_source"], .string("safari_extension"))
    XCTAssertEqual(event.parameters["has_category"], .bool(false))
  }

  func test_검색이벤트는_검색어_원문을_담지_않는다() {
    let event = ConversionEvent.searchSubmitted(queryLength: 12, resultCount: 4).event

    // 길이 구간만 나가야 한다 — 원문이 실리면 개인정보이고 GA4 100자 제한에 잘린다.
    XCTAssertEqual(event.parameters["query_length"], .string("6-15"))
    XCTAssertEqual(event.parameters["result_count"], .int(4))
    XCTAssertEqual(event.parameters["has_result"], .bool(true))
  }

  func test_결과가_없으면_has_result가_false다() {
    let event = ConversionEvent.searchSubmitted(queryLength: 3, resultCount: 0).event

    XCTAssertEqual(event.parameters["has_result"], .bool(false))
  }

  func test_화면이름은_스네이크케이스로_나간다() {
    XCTAssertEqual(
      UsageEvent.screenViewed(.linkDetail).event.parameters["screen_name"],
      .string("link_detail")
    )
    XCTAssertEqual(UsageEvent.screenViewed(.home).event.name, "screen_view")
  }

  func test_개수는_구간으로_뭉갠다() {
    XCTAssertEqual(AnalyticsValue.countBucket(0), .string("0"))
    XCTAssertEqual(AnalyticsValue.countBucket(4), .string("1-4"))
    XCTAssertEqual(AnalyticsValue.countBucket(19), .string("5-19"))
    XCTAssertEqual(AnalyticsValue.countBucket(50), .string("50+"))
    // 개수를 못 셌을 때(-1)는 0으로 뭉개지 않고 unknown으로 남긴다.
    XCTAssertEqual(AnalyticsValue.countBucket(-1), .string("unknown"))
  }

  func test_GA4로_가는_Bool은_문자열이다() {
    // GA4 리포트에서 0/1보다 true/false가 읽기 쉽다. Amplitude는 JSON이라 그대로 boolean.
    XCTAssertEqual(AnalyticsValue.bool(true).firebaseValue as? String, "true")
    XCTAssertEqual(AnalyticsValue.bool(true).amplitudeValue as? Bool, true)
  }
}
