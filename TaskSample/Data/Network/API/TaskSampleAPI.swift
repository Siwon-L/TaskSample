//
//  TaskSampleAPI.swift
//  TaskSample
//
//  Created by 이시원 on 11/6/23.
//

import Foundation

import Alamofire

struct TaskSampleAPI: APIable {
    var baseURL: String = ""
    var path: String
    var method: HTTPMethod
    var parameters: Parameters
    
    static func getBoards() -> Self {
        return TaskSampleAPI(
            path: "/boards",
            method: .get,
            parameters: [:]
        )
    }
    
    static func getPosts(boardId: Int, offset: Int, limit: Int) -> Self {
        return TaskSampleAPI(
            path: "/boards/\(boardId)/posts",
            method: .get,
            parameters: ["offset" : offset, "limit" : limit]
        )
    }
    
    static func getSearchPosts(boardId: Int, reqeust: Requestable) -> Self {
        return TaskSampleAPI(
            path: "/boards/\(boardId)/posts",
            method: .get,
            parameters: reqeust.parameter
        )
    }
}
