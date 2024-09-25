//
//  Storageable.swift
//  TaskSample
//
//  Created by 이시원 on 11/7/23.
//

import Foundation

protocol Storageable {
    func read() -> [SearchHistory]
    func save(_ value: SearchHistory) throws
    func delete(index: Int) throws
}
