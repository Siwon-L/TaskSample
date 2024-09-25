//
//  SearchCell.swift
//  TaskSample
//
//  Created by 이시원 on 11/10/23.
//

import UIKit

import SnapKit

final class SearchCell: UITableViewCell {
    private let H1Stack = UIStackView()
    private let H2Stack = UIStackView()
    private let timeIcon = UIImageView(image: MIcon.time)
    private let typeLabel = UILabel()
    private let keywordLabel = UILabel()
    private let deleteButton = UIImageButton(image: MIcon.close)
    private let nextIcon = UIImageView(image: MIcon.next)
    
    var deleteButtonDidTap: (() -> Void)? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timeIcon.isHidden = false
        deleteButton.isHidden = false
        nextIcon.isHidden = false
        deleteButtonDidTap = nil
    }
    
    private func attribute() {
        H1Stack.then {
            $0.spacing = 8
            $0.addArrangedSubview(timeIcon)
            $0.addArrangedSubview(H2Stack)
        }
        
        timeIcon.then {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        
        H2Stack.then {
            $0.alignment = .center
            $0.spacing = 3
            let label = UILabel()
            label.text = ":"
            label.font = MFont.medium_14
            label.textColor = MColor.gray600
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
            $0.addArrangedSubview(typeLabel)
            $0.addArrangedSubview(label)
            $0.addArrangedSubview(keywordLabel)
        }
        
        typeLabel.then {
            $0.font = MFont.medium_14
            $0.textColor = MColor.gray600
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        
        keywordLabel.then {
            $0.font = MFont.medium_16
            $0.textColor = MColor.chocolate700
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
        
        deleteButton.then {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.foregroundColor = MColor.gray500
            $0.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        }
        
        nextIcon.then {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
    }
    
    private func layout() {
        contentView.addSubview(H1Stack)
        H1Stack.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview().inset(16)
        }
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.width.height.equalTo(18)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(nextIcon)
        nextIcon.snp.makeConstraints {
            $0.width.height.equalTo(18)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
        timeIcon.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
    }
    
    func setContent(_ item: SearchItem) {
        timeIcon.isHidden = !item.isHistory
        deleteButton.isHidden = deleteButtonDidTap == nil
        nextIcon.isHidden = deleteButtonDidTap != nil
        keywordLabel.text = item.keyword
        switch item.searchTarget {
        case .all:
            typeLabel.text = "전체"
        case .title:
            typeLabel.text = "제목"
        case .contents:
            typeLabel.text = "내용"
        case .writer:
            typeLabel.text = "작성자"
        }
    }
    
    @objc
    private func deleteButtonAction() {
        (deleteButtonDidTap ?? {})()
    }
}
