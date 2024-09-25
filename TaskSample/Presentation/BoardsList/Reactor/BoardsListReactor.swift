//
//  BoardsListReactor.swift
//  TaskSample
//
//  Created by 이시원 on 11/8/23.
//

import Foundation

import ReactorKit

final class BoardsListReactor: Reactor {
    let initialState: State
    private let useCase: TaskSampleUseCaseable
    
    enum Action {
        case viewWillAppear
        case listCellDidTap(IndexPath)
    }
    
    enum Mutation {
        case setItems(Boards)
        case selectItem(Board)
    }
    
    struct State {
        var items: [Board] = []
        var selectedItme: Board? = nil
    }
    
    init(useCase: TaskSampleUseCaseable) {
        self.useCase = useCase
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .task(type: Boards.self) { [weak self] in
                guard let self = self else { return .empty }
                return try await self.useCase.requestBoardsList()
            }
            .map { Mutation.setItems($0) }
        case .listCellDidTap(let indexPath):
            return .just(.selectItem(currentState.items[indexPath.row]))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.selectedItme = nil
        switch mutation {
        case .setItems(let boards):
            newState.items = boards.items
            return newState
        case .selectItem(let board):
            newState.selectedItme = board
            return newState
        }
    }
}
