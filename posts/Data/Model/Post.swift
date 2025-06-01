//
//  Post.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation

struct Post: Codable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(body)
        hasher.combine(userId)
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.body == rhs.body && lhs.userId == rhs.userId
    }
    
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

extension Post {
    func switchToCreatePostRequestDTO() -> CreatPostRequestDTO { return CreatPostRequestDTO(post: self) }
}


struct CreatPostRequestDTO: Codable {
    let title: String
    let body: String
    let userId: Int
    
    init(post: Post) {
        self.title = post.title
        self.body = post.body
        self.userId = post.userId
    }
}
