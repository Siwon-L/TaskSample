//
//  APIable.swift
//  TaskSample
//
//  Created by 이시원 on 11/6/23.
//

import Foundation
import Alamofire

protocol APIable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
}

extension APIable {
    var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(.authorization(bearerToken: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2ODgxMDM5NDAsImV4cCI6MCwidXNlcm5hbWUiOiJtYWlsdGVzdEBtcC1kZXYubXlwbHVnLmtyIiwiYXBpX2tleSI6IiMhQG1wLWRldiFAIyIsInNjb3BlIjpbImVhcyJdLCJqdGkiOiI5MmQwIn0.Vzj93Ak3OQxze_Zic-CRbnwik7ZWQnkK6c83No_M780"))
        return headers
    }
}
