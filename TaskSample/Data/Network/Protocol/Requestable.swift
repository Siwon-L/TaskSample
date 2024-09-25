//
//  Requestable.swift
//  TaskSample
//
//  Created by 이시원 on 11/6/23.
//

import Foundation

protocol Requestable: Encodable {
    var parameter: [String: Any] { get }
}
