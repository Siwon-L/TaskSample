//
//  SearchPostRequest.swift
//  TaskSample
//
//  Created by 이시원 on 11/6/23.
//

import Foundation

struct SearchPostRequest: Requestable {
    let search: String
    let searchTarget: String
    let offset: Int
    let limit: Int
    
    var parameter: [String : Any] {
        return [
            "search": search,
            "searchTarget": searchTarget,
            "offset": offset,
            "limit": limit
        ]
    }
}
