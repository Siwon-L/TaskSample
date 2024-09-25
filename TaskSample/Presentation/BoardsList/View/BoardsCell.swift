//
//  BoardsCell.swift
//  TaskSample
//
//  Created by 이시원 on 11/8/23.
//

import UIKit

final class BoardsCell: UITableViewCell {
    let boardLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      attribute()
      layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        boardLabel.then {
            $0.textAlignment = .left
            $0.textColor = MColor.chocolate700
            $0.font = MFont.bold_16
        }
    }
    
    private func layout() {
        addSubview(boardLabel)
        boardLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview().inset(16)
        }
    }
}
