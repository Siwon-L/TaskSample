//
//  UIColor+.swift
//  TaskSample
//
//  Created by 이시원 on 11/8/23.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
