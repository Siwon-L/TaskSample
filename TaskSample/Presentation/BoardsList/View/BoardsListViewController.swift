//
//  BoardsListViewController.swift
//  TaskSample
//
//  Created by 이시원 on 11/8/23.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class BoardsListViewController: UIViewController {
    private let appBar = AppBar(
        leftItemImage: MIcon.close
    )
    
    private let contentView = BoardsListView()
    
    private let reactor: BoardsListReactor
    private let disposeBag = DisposeBag()
    
    init(reactor: BoardsListReactor) {
      self.reactor = reactor
      super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind(reactor)
    }

    private func attribute() {
        view.backgroundColor = .systemBackground
    }
    
    private func layout() {
        view.addSubview(appBar)
        appBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(appBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind(_ reactor: BoardsListReactor) {
      bindAction(reactor)
      bindState(reactor)
    }
    
    private func bindAction(_ reactor: BoardsListReactor) {
        self.rx.viewWillAppear
            .map { _ in BoardsListReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        contentView.rx.list.itemSelected
            .map { BoardsListReactor.Action.listCellDidTap($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        appBar.rx.leftButtonDidTap
            .bind(to: dismiss)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: BoardsListReactor) {
        reactor.state.map { $0.items }
            .bind(to: contentView.rx.list.items(
                cellIdentifier: BoardsCell.identifier,
                cellType: BoardsCell.self
            )) { index, item, cell in
                cell.boardLabel.text = item.name
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedItme }
          .filter { $0 != nil }
          .bind(to: postItemToRootView)
          .disposed(by: disposeBag)
    }
}

extension BoardsListViewController {
    private var postItemToRootView: Binder<Board?> {
        return Binder(self) { owner, item in
            guard let item = item else { return }
            NotificationCenter.default.post(name: .postBoardToRoot, object: item)
            owner.dismiss(animated: true)
        }
    }
    
    private var dismiss: Binder<Void> {
        return Binder(self) { owner, _ in
            owner.dismiss(animated: true)
        }
    }
}
