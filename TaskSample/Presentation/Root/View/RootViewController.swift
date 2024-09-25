//
//  RootViewController.swift
//  TaskSample
//
//  Created by 이시원 on 11/6/23.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa

class RootViewController: UIViewController {
    private let appBar = AppBar(
        title: "",
        leftItemImage: MIcon.menu,
        rightItemImage: MIcon.search
    )
    
    private let searchBar = SearchBar()
    private let postList = UITableView()
    private let searchList = UITableView()
    private let searchHistoryEmptyGuideView = GuideView.searchHistoryEmpty
    private let registeredPostDataEmptyGuideView = GuideView.registeredPostDataEmpty
    private let searchResultEmptyGuideView = GuideView.searchResultEmpty

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind(reactor)
    }
    
    private let reactor: RootReactor
    private let disposeBag = DisposeBag()
    private let dateFormater = DateFormatter()
    
    init(reactor: RootReactor) {
        self.reactor = reactor
        dateFormater.dateFormat = "YY-MM-DD"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func attribute() {
        view.backgroundColor = .systemBackground
        
        postList.then {
            $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
            $0.separatorStyle = .none
            $0.backgroundColor = MColor.gray100
        }
        
        searchList.then {
            $0.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
            $0.backgroundColor = MColor.gray100
        }
        
        searchHistoryEmptyGuideView.isHidden = true
        registeredPostDataEmptyGuideView.isHidden = true
        searchResultEmptyGuideView.isHidden = true
    }
    
    private func layout() {
        view.addSubview(appBar)
        appBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
        
        view.addSubview(postList)
        postList.snp.makeConstraints {
            $0.top.equalTo(appBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        postList.addSubview(registeredPostDataEmptyGuideView)
        registeredPostDataEmptyGuideView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(view.snp.centerY)
        }
        postList.addSubview(searchResultEmptyGuideView)
        searchResultEmptyGuideView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(view.snp.centerY)
        }
        
        view.addSubview(searchList)
        searchList.snp.makeConstraints {
            $0.top.equalTo(appBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        searchList.addSubview(searchHistoryEmptyGuideView)
        searchHistoryEmptyGuideView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(80)
        }
    }
    
    private func bind(_ reactor: RootReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: RootReactor) {
        NotificationCenter.default.rx.notification(.postBoardToRoot)
            .compactMap { $0.object as? Board }
            .map { RootReactor.Action.catchBoradInfo($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        appBar.rx.leftButtonDidTap
            .bind(to: presentBoardsListView)
            .disposed(by: disposeBag)
        
        appBar.rx.rightButtonDidTap
            .map { _ in RootReactor.Action.searchButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonDidTap
            .map { _ in RootReactor.Action.cancelButtonDidTap }
            .map { [ weak self ] in
                self?.searchBar.textField.text = ""
                return $0
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in RootReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        postList.rx.prefetchRows
          .compactMap { $0.first?.row }
          .map { RootReactor.Action.prefetchRows($0) }
          .bind(to: reactor.action)
          .disposed(by: disposeBag)
        
        searchBar.rx.text
            .filter { $0 != "" || $0 != nil }
            .map { RootReactor.Action.inputKeyword($0 ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .map { RootReactor.Action.inputKeyword($0 ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchList.rx.itemSelected
            .map { RootReactor.Action.searchCellDidTap($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchBar.rx.editing
            .map { RootReactor.Action.searchButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: RootReactor) {
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: appBar.rx.title)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.posts }
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: postList.rx.items(
                cellIdentifier: PostCell.identifier,
                cellType: PostCell.self
            )) { [weak self] index, item, cell in
                guard let self = self else { return }
                cell.setContent(post: item, dateFormatter: self.dateFormater, searchItem: reactor.currentState.selectedSearchItem)
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.searchItems }
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: searchList.rx.items(
                cellIdentifier: SearchCell.identifier,
                cellType: SearchCell.self
            )) { [weak self] index, item, cell in
                guard let self = self else { return }
                if item.isHistory {
                    cell.deleteButtonDidTap = {
                        Observable.just(index)
                            .map { RootReactor.Action.searchCellDeleteButtonDidTap($0) }
                            .bind(to: self.reactor.action)
                            .disposed(by: self.disposeBag)
                    }
                }
                cell.setContent(item)
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.isSearchMode }
            .distinctUntilChanged()
            .map { !$0 }
            .bind(to: searchBar.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSearchEndEditing }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: setSearchMode)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.title }
            .map { "\($0)에서 검색" }
            .distinctUntilChanged()
            .bind(to: searchBar.rx.placeholder)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedSearchItem }
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: searchBar.rx.searchType)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.searchItems }
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .bind(to: searchHistoryEmptyGuideView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.posts }
            .map { $0.isEmpty }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: setGuideView)
            .disposed(by: disposeBag)
    }
    
    private var setSearchMode: Binder<Bool> {
        return Binder(self) { owner, value in
            if value {
                owner.searchBar.textField.resignFirstResponder()
            } else {
                owner.searchBar.textField.becomeFirstResponder()
            }
            owner.searchList.isHidden = value
        }
    }
    
    private var setGuideView: Binder<Bool> {
        return Binder(self) { owner, value in
            if value {
                if owner.reactor.currentState.selectedSearchItem == nil {
                    owner.registeredPostDataEmptyGuideView.isHidden = false
                    owner.searchResultEmptyGuideView.isHidden = true
                } else {
                    owner.registeredPostDataEmptyGuideView.isHidden = true
                    owner.searchResultEmptyGuideView.isHidden = false
                }
            } else {
                owner.registeredPostDataEmptyGuideView.isHidden = true
                owner.searchResultEmptyGuideView.isHidden = true
            }
        }
    }
    
    private var presentBoardsListView: Binder<Void> {
        return Binder(self) { owner, _ in
            let useCase = TaskSampleUseCase(apiManager: APIManager(), searchHistoryStorage: SearchHistoryStorage())
            let reactor = BoardsListReactor(useCase: useCase)
            owner.present(BoardsListViewController(reactor: reactor), animated: true)
        }
    }
}


