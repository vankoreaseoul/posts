//
//  Post.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}
