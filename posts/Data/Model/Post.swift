//
//  Post.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation

struct Post: Codable, Identifiable, Equatable {
    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//        hasher.combine(title)
//        hasher.combine(body)
//        hasher.combine(userId)
//    }
//    
//    static func == (lhs: Post, rhs: Post) -> Bool {
//        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.body == rhs.body && lhs.userId == rhs.userId
//    }
    
    let id: Int
    let title: String
    let body: String
    let userId: Int
}


struct CreatPostRequestDTO: Codable {
    let title: String
    let body: String
    let userId: Int
}

extension CreatPostRequestDTO {
    init(from post: Post) {
        title = post.title
        body = post.body
        userId = post.userId
    }
}
