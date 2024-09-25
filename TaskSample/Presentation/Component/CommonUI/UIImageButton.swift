//
//  UIImageButton.swift
//  TaskSample
//
//  Created by 이시원 on 11/7/23.
//

import UIKit

final class UIImageButton: UIButton {
    var foregroundColor: UIColor = .blue {
        didSet {
            tintColor = foregroundColor
        }
    }
    
    init(image: UIImage? = nil) {
        super.init(frame: .zero)
        if let image = image {
            self.setImage(image, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            tintColor = isHighlighted ? foregroundColor.withAlphaComponent(0.7) : foregroundColor
        }
    }
}
