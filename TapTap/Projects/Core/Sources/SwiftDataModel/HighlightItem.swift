//
//  HighlightItem.swift
//  Domain
//
//  Created by 여성일 on 10/16/25.
//

import Foundation
import SwiftData

public struct Comment: Codable, Hashable {
    public let id: Double // 메모를 구분하기 위한 고유 ID
    public let type: String // 메모의 종류 (What/Why/Detail)
    public let text: String // 코멘트 내용
    
    public init(id: Double, type: String, text: String) {
        self.id = id
        self.type = type
        self.text = text
    }
}

// HighlightItem은 TapTapSchema.swift에서 VersionedSchema로 정의되어 있습니다.
