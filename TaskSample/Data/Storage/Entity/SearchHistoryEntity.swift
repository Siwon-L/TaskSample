//
//  SearchHistoryEntity.swift
//  TaskSample
//
//  Created by 이시원 on 11/7/23.
//

import Foundation

import RealmSwift

final class SearchHistoryEntity: Object {
    @Persisted private var searchTarget: String
    @Persisted private var keyword: String
    @Persisted(primaryKey: true) var id: UUID
    
    convenience init(_ value: SearchHistory) {
        self.init()
        self.searchTarget = value.searchTarget.rawValue
        self.keyword = value.keyword
        self.id = UUID()
    }
    
    var toDomain: SearchHistory {
        guard let searchTarget = SearchTarget(rawValue: searchTarget) else {
            fatalError("SearchTarget 값이 올바르지 않습니다.")
        }
        return SearchHistory(
            searchTarget: searchTarget,
            keyword: keyword
        )
    }
}
