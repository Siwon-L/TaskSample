//
//  BoardsListView.swift
//  TaskSample
//
//  Created by 이시원 on 11/8/23.
//

import UIKit

final class BoardsListView: UIView {
    fileprivate let headerLabel = UILabel()
    private let divider = UIView()
    fileprivate let boardsList = UITableView()
    
    init() {
        super.init(frame: .zero)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        headerLabel.then {
            $0.text = "게시판"
            $0.font = MFont.thin_14
            $0.textColor = MColor.chocolate700
        }
        
        divider.then {
            $0.backgroundColor = MColor.gray200
        }
        
        boardsList.then {
            $0.register(BoardsCell.self, forCellReuseIdentifier: BoardsCell.identifier)
            $0.separatorStyle = .none
        }
    }
    
    private func layout() {
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
        }
        addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).inset(-16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        addSubview(boardsList)
        boardsList.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

import RxSwift

extension Reactive where Base: BoardsListView {
    var list: Reactive<UITableView> {
        return base.boardsList.rx
    }
}
