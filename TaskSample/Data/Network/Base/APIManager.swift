//
//  APIManager.swift
//  TaskSample
//
//  Created by 이시원 on 11/6/23.
//

import Foundation

import Alamofire

struct APIManager: APIManagerable {
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
}

// MARK: - Request

extension APIManager {
    func request<T: Decodable>(_ api: APIable, type: T.Type) async throws -> T {
        let data = try await request(api)
        let result = try JSONDecoder().decode(type, from: data)
        
        return result
    }
    
    func request(_ api: APIable) async throws -> Data {
        let dataRequest = try dataRequest(api)
        let result = dataRequest
            .serializingResponse(using: .data)
        
        return try await result.value
    }
    
    private func dataRequest(_ api: APIable) throws -> DataRequest {
        guard let url = URL(string: "\(api.baseURL)\(api.path)") else {
            throw NetworkError.createURLError
        }
        
        return session.request(
            url,
            method: api.method,
            parameters: api.parameters,
            headers: api.headers
        ).validate(statusCode: 200..<300)
    }
}
