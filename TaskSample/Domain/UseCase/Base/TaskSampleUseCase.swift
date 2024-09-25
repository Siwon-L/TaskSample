//
//  TaskSampleUseCase.swift
//  TaskSample
//
//  Created by 이시원 on 11/7/23.
//

import Foundation

final class TaskSampleUseCase: TaskSampleUseCaseable {
    private let apiManager: APIManagerable
    let searchHistoryStorage: Storageable
    
    init(apiManager: APIManagerable, searchHistoryStorage: Storageable) {
        self.apiManager = apiManager
        self.searchHistoryStorage = searchHistoryStorage
    }
    
    func requestBoardsList() async throws -> Boards {
        let api = TaskSampleAPI.getBoards()
        return try await apiManager.request(api, type: BoardsResponse.self).toDomain
    }
    
    func requestPosts(boardId: Int, offset: Int, limit: Int) async throws -> Posts {
        let api = TaskSampleAPI.getPosts(boardId: boardId, offset: offset, limit: limit)
        return try await apiManager.request(api, type: PostsResponse.self).toDomain
    }
    
    func readSearchHistory() -> [SearchHistory] {
        return searchHistoryStorage.read().reversed()
    }
    
    func removeSearchHistory(index: Int) -> [SearchHistory] {
        let count = searchHistoryStorage.read().count
        try? searchHistoryStorage.delete(index: count - index - 1)
        return searchHistoryStorage.read().reversed()
    }
    
    func searchPosts(boardId: Int, item: SearchItem, offset: Int, limit: Int) async throws -> Posts {
        DispatchQueue.main.async {
            if let index = self.searchHistoryStorage.read().firstIndex(where: { $0.keyword == item.keyword && $0.searchTarget == item.searchTarget }) {
                try? self.searchHistoryStorage.delete(index: index)
            }
            try? self.searchHistoryStorage.save(.init(searchTarget: item.searchTarget, keyword: item.keyword))
        }
        let reqeust = SearchPostRequest(search: item.keyword, searchTarget: item.searchTarget.rawValue, offset: offset, limit: limit)
        let api = TaskSampleAPI.getSearchPosts(boardId: boardId, reqeust: reqeust)
        return try await apiManager.request(api, type: PostsResponse.self).toDomain
    }
}
