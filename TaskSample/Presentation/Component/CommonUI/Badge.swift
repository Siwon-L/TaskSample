//
//  Badge.swift
//  TaskSample
//
//  Created by 이시원 on 11/9/23.
//

import UIKit

import SnapKit

final class Badge: UIView {
    private let label = UILabel()
    
    init(text: String) {
        super.init(frame: .zero)
        label.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBackgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    func attribute(font: UIFont, radius: CGFloat) -> Self {
        self.then {
            $0.layer.cornerRadius = radius
        }
        
        label.then {
            $0.font = font
            $0.textColor = .white
        }
        
        return self
    }
    
    func layout(width: Int, height: Int) -> Self {
        addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.height.equalTo(height)
            $0.width.equalTo(width)
        }
        
        return self
    }
}

extension Badge {
    static var notice: Badge {
        return Badge(text: "공지")
            .setBackgroundColor(MColor.warning500)
            .attribute(font: MFont.medium_12, radius: 10)
            .layout(width: 39, height: 20)
    }
    
    static var reply: Badge {
        return Badge(text: "Re")
            .setBackgroundColor(MColor.timberwolf900)
            .attribute(font: MFont.medium_12, radius: 10)
            .layout(width: 31, height: 20)
    }
    
    static var new: Badge {
        return Badge(text: "N")
            .setBackgroundColor(MColor.orange600)
            .attribute(font: MFont.medium_10, radius: 6)
            .layout(width: 16, height: 13)
    }
}
