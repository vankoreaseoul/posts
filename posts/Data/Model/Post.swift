//
//  Post.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation

struct Post: Codable, Identifiable {
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
