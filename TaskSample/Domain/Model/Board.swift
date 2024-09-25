//
//  Board.swift
//  TaskSample
//
//  Created by 이시원 on 11/8/23.
//

import Foundation

struct Boards {
    let items: [Board]
    let count: Int
    let offset: Int
    let limit: Int
    let total: Int
    
    static var empty: Boards {
        Boards(items: [], count: 0, offset: 0, limit: 0, total: 0)
    }
}

struct Board {
    let boardId: Int
    let name: String
}
