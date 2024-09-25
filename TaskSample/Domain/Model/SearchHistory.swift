//
//  SearchHistory.swift
//  TaskSample
//
//  Created by 이시원 on 11/7/23.
//

import Foundation

struct SearchHistory {
    let searchTarget: SearchTarget
    let keyword: String
    
    var toItem: SearchItem {
        SearchItem(isHistory: true, searchTarget: searchTarget, keyword: keyword)
    }
}
