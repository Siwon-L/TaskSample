//
//  Collection+.swift
//  TaskSample
//
//  Created by 이시원 on 11/10/23.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
