//
//   AppBar.swift
//  TaskSample
//
//  Created by 이시원 on 11/7/23.
//

import UIKit

import SnapKit

final class AppBar: UIView {
    private let HStackView = UIStackView()
    fileprivate let leftItem = UIImageButton()
    fileprivate let titleLabel = UILabel()
    fileprivate let rightItem = UIImageButton()
    
    init(title: String? = nil, leftItemImage: UIImage? = nil, rightItemImage: UIImage? = nil) {
        super.init(frame: .zero)
        attribute(title: title, leftItemImage: leftItemImage, rightItemImage: rightItemImage)
        layout()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute(title: String?, leftItemImage: UIImage?, rightItemImage: UIImage?) {
        backgroundColor = .white
        
        HStackView.then {
            $0.addArrangedSubview(leftItem)
            $0.addArrangedSubview(titleLabel)
            $0.addArrangedSubview(rightItem)
            $0.spacing = 20
        }
        
        leftItem.then {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.foregroundColor = .label
            if let image = leftItemImage {
                $0.setImage(image, for: .normal)
            } else {
                $0.isHidden = true
            }
        }
        
        titleLabel.then {
            $0.textAlignment = .left
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
            $0.font = MFont.bold_22
            $0.text = title
        }
        
        rightItem.then {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.foregroundColor = .label
            if let image = rightItemImage {
                $0.setImage(image, for: .normal)
            } else {
                $0.isHidden = true
            }
        }
        
    }
    
    private func layout() {
        addSubview(HStackView)
        HStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

import RxSwift
import RxCocoa

extension Reactive where Base: AppBar {
    var title: Binder<String?> {
        return base.titleLabel.rx.text
    }
    
    var leftButtonDidTap: ControlEvent<Void> {
        return base.leftItem.rx.tap
    }
    
    var rightButtonDidTap: ControlEvent<Void> {
        return base.rightItem.rx.tap
    }
}
