//
//  Icon.swift
//  TaskSample
//
//  Created by 이시원 on 11/7/23.
//

import UIKit

final class MIcon {
    static let menu = UIImage(named: "menuIcon")
    static let search = UIImage(named: "searchIcon")
    static let close = UIImage(named: "closeIcon")
    static let clip = UIImage(named: "clipIcon")
    static let eye = UIImage(named: "eyeIcon")
    static let time = UIImage(named: "timeIcon")
    static let next = UIImage(named: "nextIcon")
}

extension UIImage {
    func resized(width: CGFloat, height: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: .init(width: width, height: height)).image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
