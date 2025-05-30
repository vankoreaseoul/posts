//
//  Comment.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation

struct Comment: Codable {
    let id: Int
    let name: String
    let email: String
    let body: String
    let postId: Int
}
