//
//  BoardsResponse.swift
//  TaskSample
//
//  Created by 이시원 on 11/6/23.
//

import Foundation

struct BoardsResponse: Decodable {
    let value: [BoardsDataType]
    let count: Int
    let offset: Int
    let limit: Int
    let total: Int
    
    var toDomain: Boards {
        Boards(
            items: value.map { $0.toDomain },
            count: count,
            offset: offset,
            limit: limit,
            total: total
        )
    }
}

struct BoardsDataType: Decodable {
    let boardId: Int
    let displayName: String
    let boardType: String
    let isFavorite: Bool
    let hasNewPost: Bool
    let orderNo: Int
    let capability: CapabilityDataType
    
    var toDomain: Board {
        Board(
            boardId: boardId,
            name: displayName
        )
    }
}

struct CapabilityDataType: Decodable {
    let writable: Bool
    let manageable: Bool
}
