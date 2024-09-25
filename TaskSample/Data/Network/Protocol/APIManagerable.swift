//
//  APIManagerable.swift
//  TaskSample
//
//  Created by 이시원 on 11/6/23.
//

import Foundation

import Foundation

protocol APIManagerable {
    func request<T: Decodable>(_ api: APIable, type: T.Type) async throws -> T
    func request(_ api: APIable) async throws -> Data
}
