//
//  SearchItem.swift
//  TaskSample
//
//  Created by 이시원 on 11/10/23.
//

import Foundation

struct SearchItem {
    let isHistory: Bool
    let searchTarget: SearchTarget
    let keyword: String
    
    static func defaultItems(keyword: String) -> [Self] {
        return [
            SearchItem(isHistory: false, searchTarget: .all, keyword: keyword),
            SearchItem(isHistory: false, searchTarget: .title, keyword: keyword),
            SearchItem(isHistory: false, searchTarget: .contents, keyword: keyword),
            SearchItem(isHistory: false, searchTarget: .writer, keyword: keyword)
        ]
    }
}
