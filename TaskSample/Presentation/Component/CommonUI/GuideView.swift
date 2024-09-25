//
//  GuideImage.swift
//  TaskSample
//
//  Created by 이시원 on 11/11/23.
//

import UIKit

import SnapKit

final class GuideView: UIView {
    private let VStack = UIStackView()
    private let imageView = UIImageView()
    private let labelView = UILabel()
    
    init(text: String, image: UIImage?) {
        super.init(frame: .zero)
        attribute(text: text, image: image)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute(text: String, image: UIImage?) {
        backgroundColor = .clear
        
        VStack.then {
            $0.axis = .vertical
            $0.spacing = 16
            $0.alignment = .center
            $0.addArrangedSubview(imageView)
            $0.addArrangedSubview(labelView)
        }
        
        imageView.then {
            $0.image = image
        }
        
        labelView.then {
            $0.numberOfLines = 0
            $0.text = text
            $0.textColor = MColor.gray600
            $0.font = MFont.medium_14
            $0.textAlignment = .center
        }
    }
    
    private func layout() {
        addSubview(VStack)
        VStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension GuideView {
    static var searchHistoryEmpty: GuideView {
        return GuideView(text: "게시글의 제목, 내용 또는 작성자에 포함된\n단어 또는 문장을 검색해 주세요.", image: UIImage(named: "searchHistoryEmptyImage"))
    }
    
    static var registeredPostDataEmpty: GuideView {
        return GuideView(text: "등록된 게시글이 없습니다.", image: UIImage(named: "registeredPostDataEmptyImage"))
    }
    
    static var searchResultEmpty: GuideView {
        return GuideView(text: "검색 결과가 없습니다.\n다른 검색어를 입력해 보세요.", image: UIImage(named: "searchResultEmptyImage"))
    }
}
