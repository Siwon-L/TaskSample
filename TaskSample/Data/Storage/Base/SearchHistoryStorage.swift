//
//  SearchHistoryStorage.swift
//  TaskSample
//
//  Created by 이시원 on 11/7/23.
//

import Foundation

import RealmSwift

final class SearchHistoryStorage: Storageable {
    private let realm = try? Realm()
    private var storage: [SearchHistory]
    private let items: Results<SearchHistoryEntity>?
    
    init() {
        self.items = realm?.objects(SearchHistoryEntity.self)
        self.storage = items?.map { $0.toDomain } ?? []
    }
    
    func read() -> [SearchHistory] {
         return storage
    }
    
    func save(_ value: SearchHistory) throws {
        try realm?.write({
            guard let items = items else { return }
            realm?.add(SearchHistoryEntity(value))
            storage = items.map { $0.toDomain }
        })
    }
    
    func delete(index: Int) throws {
        try realm?.write({
            guard let items = items else { return }
            guard let item = items[safe: index] else { return }
            realm?.delete(item)
            storage = items.map { $0.toDomain }
        })
    }
}
