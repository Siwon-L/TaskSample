//
//  TaskSampleUseCaseable.swift
//  TaskSample
//
//  Created by 이시원 on 11/7/23.
//

import Foundation

protocol TaskSampleUseCaseable {
    var searchHistoryStorage: Storageable { get }
    func requestBoardsList() async throws -> Boards
    func requestPosts(boardId: Int, offset: Int, limit: Int) async throws -> Posts
    func readSearchHistory() -> [SearchHistory]
    func removeSearchHistory(index: Int) -> [SearchHistory]
    func searchPosts(boardId: Int, item: SearchItem, offset: Int, limit: Int) async throws -> Posts
}
