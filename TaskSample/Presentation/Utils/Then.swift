//
//  Then.swift
//  TaskSample
//
//  Created by 이시원 on 11/7/23.
//

import Foundation

protocol Then {}

extension Then where Self: AnyObject {
    @inlinable
    @discardableResult
    func then(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

extension NSObject: Then {}
