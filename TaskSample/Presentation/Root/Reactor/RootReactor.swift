//
//  RootReactor.swift
//  TaskSample
//
//  Created by 이시원 on 11/8/23.
//

import Foundation

import ReactorKit

final class RootReactor: Reactor {
    let initialState: State
    private let useCase: TaskSampleUseCaseable
    
    enum Action {
        case viewWillAppear
        case catchBoradInfo(Board)
        case prefetchRows(Int)
        case searchButtonDidTap
        case cancelButtonDidTap
        case searchCellDeleteButtonDidTap(Int)
        case searchCellDidTap(IndexPath)
        case inputKeyword(String)
        
    }
    
    enum Mutation {
        case addPosts([Post])
        case setContent(Posts, String, Int)
        case setLoading(Bool)
        case changeAppBar(Bool)
        case setSearchKeywordList([SearchItem])
        case setSearchItem(Posts, SearchItem?)
        case none
    }
    
    struct State {
        var title = ""
        var boardId: Int? = nil
        var offset: Int = 0
        var limit = 30
        var posts: [Post] = []
        var total = 0
        var postCount = 0
        var isLoding = false
        var isSearchMode = false
        var isSearchEndEditing = true
        var searchItems: [SearchItem] = []
        var selectedSearchItem: SearchItem? = nil
    }
    
    init(useCase: TaskSampleUseCaseable) {
        self.useCase = useCase
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .catchBoradInfo(let board):
            return .task(type: Posts.self) { [weak self] in
                guard let self = self else { return .empty }
                return try await self.useCase.requestPosts(boardId: board.boardId, offset: 0, limit: currentState.limit)
            }
            .map { .setContent($0, board.name, board.boardId) }
        case .viewWillAppear:
            return Observable.concat([
                .task(type: (Posts, String, Int).self) { [weak self] in
                    guard let self = self else { return (Posts.empty, "", 0) }
                    let board = try await self.useCase.requestBoardsList().items.first!
                    let posts = try await self.useCase.requestPosts(boardId: board.boardId, offset: 0, limit: self.currentState.limit)
                    return (posts, board.name, board.boardId)
                }
                .map { .setContent($0, $1, $2) },
                .just(.setSearchKeywordList(useCase.readSearchHistory().map { $0.toItem }))
            ])

        case .prefetchRows(let prefetchRow):
            guard checkLoadable(prefetchRow: prefetchRow) else {
                return .never()
            }
            if let selectedSearchItem = currentState.selectedSearchItem {
                return Observable.concat([
                    .just(.setLoading(true)),
                    .task(type: Posts.self) { [weak self] in
                        guard let self = self else { return .empty}
                        return try await self.useCase.searchPosts(boardId: self.currentState.boardId!, item: selectedSearchItem,
                            offset: self.currentState.offset,
                            limit: self.currentState.limit
                        )
                    }
                    .map { [weak self] in
                        guard let self = self else { return .none }
                        return .addPosts(self.currentState.posts + $0.items)
                    },
                    .just(.setLoading(false))
                ])
            } else {
                return Observable.concat([
                    .just(.setLoading(true)),
                    .task(type: Posts.self) { [weak self] in
                        guard let self = self else { return .empty}
                        return try await self.useCase.requestPosts(
                            boardId: self.currentState.boardId!,
                            offset: self.currentState.offset,
                            limit: self.currentState.limit
                        )
                    }
                    .map { [weak self] in
                        guard let self = self else { return .none }
                        return .addPosts(self.currentState.posts + $0.items)
                    },
                    .just(.setLoading(false))
                ])
            }
            
        case .searchButtonDidTap:
            return .just(.changeAppBar(true))
        case .cancelButtonDidTap:
            return Observable.concat([
                .just(.changeAppBar(false)),
                .just(.setSearchKeywordList(useCase.readSearchHistory().map { $0.toItem })),
                .task(type: (Posts, String, Int).self) { [weak self] in
                    guard let self = self else { return (Posts.empty, "", 0) }
                    let posts = try await self.useCase.requestPosts(boardId: currentState.boardId ?? 0, offset: 0, limit: self.currentState.limit)
                    return (posts, currentState.title, currentState.boardId ?? 0)
                }
                .map { .setContent($0, $1, $2) }
            ])
            
        case .searchCellDeleteButtonDidTap(let index):
            return .just(.setSearchKeywordList(useCase.removeSearchHistory(index: index).map { $0.toItem }))
        case .inputKeyword(let keyword):
            if keyword == "" {
                return .just(.setSearchKeywordList(useCase.readSearchHistory().map { $0.toItem }))
            } else {
                return .just(.setSearchKeywordList(SearchItem.defaultItems(keyword: keyword)))
            }
        case .searchCellDidTap(let indexPath):
            return .task(type: (Posts, SearchItem?).self) { [weak self] in
                guard let self = self else { return (Posts.empty, nil) }
                let posts = try await self.useCase.searchPosts(
                    boardId: currentState.boardId ?? 0,
                    item: currentState.searchItems[indexPath.row],
                    offset: 0,
                    limit: currentState.limit
                )
                return (posts, currentState.searchItems[indexPath.row])
            }
            .map { .setSearchItem($0, $1) }
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .addPosts(let posts):
            newState.posts = posts
            newState.postCount = posts.count
            newState.offset = currentState.offset + currentState.limit
        case .setContent(let posts, let title, let id):
            newState.posts = posts.items
            newState.postCount = posts.items.count
            newState.total = posts.total
            newState.title = title
            newState.boardId = id
            newState.offset = currentState.limit
        case .setSearchItem(let posts, let searchItem):
            newState.posts = posts.items
            newState.postCount = posts.items.count
            newState.total = posts.total
            newState.offset = currentState.limit
            newState.selectedSearchItem = searchItem
            newState.isSearchEndEditing = true
        case .setLoading(let isLoading):
            newState.isLoding = isLoading
        case .none:
            break
        case .changeAppBar(let value):
            newState.isSearchMode = value
            newState.isSearchEndEditing = !value
            newState.selectedSearchItem = nil
        case .setSearchKeywordList(let items):
            newState.searchItems = items
        }
        return newState
    }
}

private extension RootReactor {
    func checkLoadable(prefetchRow: Int) -> Bool {
        let paginationRow = currentState.offset - currentState.limit / 3
        return currentState.offset <= currentState.postCount
        && currentState.offset <= currentState.total
        && !currentState.isLoding
        && prefetchRow > paginationRow
    }
}
