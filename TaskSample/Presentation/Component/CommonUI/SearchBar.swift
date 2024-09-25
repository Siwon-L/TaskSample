//
//  SearchBar.swift
//  TaskSample
//
//  Created by 이시원 on 11/9/23.
//

import UIKit

import SnapKit

final class SearchBar: UIView {
    private let backgroundView = UIView()
    private let H1Stack = UIStackView()
    private let H2Stack = UIStackView()
    private let searchIcon = UIImageView(image: MIcon.search)
    let textField = UITextField()
    fileprivate let cancelButton = UIButton()
    fileprivate let typeLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        backgroundColor = .white
        
        
        backgroundView.then {
            $0.layer.cornerRadius = 3
            $0.backgroundColor = MColor.gray100
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
        
        H1Stack.then {
            $0.spacing = 8
            $0.addArrangedSubview(backgroundView)
            $0.addArrangedSubview(cancelButton)
        }
        
        H2Stack.then {
            $0.spacing = 5
            $0.alignment = .center
            $0.addArrangedSubview(searchIcon)
            $0.addArrangedSubview(typeLabel)
            $0.addArrangedSubview(textField)
        }
        
        searchIcon.then {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.contentMode = .scaleAspectFit
            $0.tintColor = MColor.chocolate700
        }
        
        typeLabel.then {
            $0.font = MFont.medium_14
            $0.textColor = MColor.gray600
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        
        textField.then {
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
            
        }
        
        cancelButton.then {
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(MColor.gray600, for: .normal)
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
    }
    
    private func layout() {
        addSubview(H1Stack)
        H1Stack.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        backgroundView.addSubview(H2Stack)
        H2Stack.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(14)
        }
        
        searchIcon.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
    }
}

import RxSwift
import RxCocoa

extension Reactive where Base: SearchBar {
    var cancelButtonDidTap: ControlEvent<Void> {
        return base.cancelButton.rx.tap
    }
    
    var placeholder: Binder<String?> {
        return base.textField.rx.placeholder
    }
    
    var text: ControlProperty<String?> {
        return base.textField.rx.text
    }
    
    var editing: ControlEvent<Void> {
        return base.textField.rx.beginEditing
    }
    
    var searchType: Binder<SearchItem?> {
        return Binder(base) { base, item in
            if let item = item {
                base.textField.text = item.keyword
                base.typeLabel.isHidden = false
                switch item.searchTarget {
                case .all:
                    base.typeLabel.text = "전체 :"
                case .title:
                    base.typeLabel.text = "제목 :"
                case .contents:
                    base.typeLabel.text = "내용 :"
                case .writer:
                    base.typeLabel.text = "작성자 :"
                }
            } else {
                base.typeLabel.isHidden = true
            }
            
        }
    }
}

extension Reactive where Base : UITextField {
    var beginEditing : ControlEvent<Void> {
        return controlEvent(.editingDidBegin)
    }
}
