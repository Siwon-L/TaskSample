//
//  Post.swift
//  TaskSample
//
//  Created by 이시원 on 11/8/23.
//

import Foundation

struct Posts {
    let items: [Post]
    let count: Int
    let offset: Int
    let limit: Int
    let total: Int
    
    static var empty: Posts {
        Posts(items: [], count: 0, offset: 0, limit: 0, total: 0)
    }
}

struct Post {
    let postId: Int
    let title: String
    let boardId: Int
    let boardName: String
    let writer: Writer
    let contents: String
    let createdDateTime: String
    let viewCount: Int
    let postType: PostType
    let isNewPost: Bool
    let hasInlineImage: Bool
    let commentsCount: Int
    let attachmentsCount: Int
    let isAnonymous: Bool
    let isOwner: Bool
    let hasReply: Bool
}
