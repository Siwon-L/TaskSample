//
//  PostsResponse.swift
//  TaskSample
//
//  Created by 이시원 on 11/6/23.
//

import Foundation

struct PostsResponse: Decodable {
    let value: [PostDataType]
    let count: Int
    let offset: Int
    let limit: Int
    let total: Int
    
    var toDomain: Posts {
        Posts(
            items: value.map { $0.toDomain },
            count: count,
            offset: offset,
            limit: limit,
            total: total
        )
    }
}

struct PostDataType: Decodable {
    let postId: Int
    let title: String
    let boardId: Int
    let boardDisplayName: String
    let writer: WriterDataType
    let contents: String
    let createdDateTime: String
    let viewCount: Int
    let postType: String
    let isNewPost: Bool
    let hasInlineImage: Bool
    let commentsCount: Int
    let attachmentsCount: Int
    let isAnonymous: Bool
    let isOwner: Bool
    let hasReply: Bool
    
    var toDomain: Post {
        Post(
            postId: postId,
            title: title,
            boardId: boardId,
            boardName: boardDisplayName,
            writer: writer.toDomain,
            contents: contents,
            createdDateTime: createdDateTime,
            viewCount: viewCount,
            postType: PostType(rawValue: postType) ?? .normal,
            isNewPost: isNewPost,
            hasInlineImage: hasInlineImage,
            commentsCount: commentsCount,
            attachmentsCount: attachmentsCount,
            isAnonymous: isAnonymous,
            isOwner: isOwner,
            hasReply: hasReply
        )
    }
}

struct WriterDataType: Decodable {
    let displayName: String
    let emailAddress: String
    
    var toDomain: Writer {
        Writer(name: displayName, email: emailAddress)
    }
}
