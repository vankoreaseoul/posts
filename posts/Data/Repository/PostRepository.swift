//
//  PostRepository.swift
//  posts
//
//  Created by Heawon Seo on 5/28/25.
//

import Foundation
import Moya

protocol PostRepository {
    func fetchPosts() async throws -> [Post]
    func fetchPost(id: Int) async throws -> Post
    func fetchComments(postId: Int) async throws -> [Comment]
    func createPost(post: Post) async throws -> Post
}

final class DefaultPostRepository: PostRepository {
    private let provider = MoyaProvider<PostAPI>()
    
    func fetchPosts() async throws -> [Post] { return try await provider.asyncRequest([Post].self, .getPosts) }
    
    func fetchPost(id: Int) async throws -> Post { return try await provider.asyncRequest(Post.self, .getPost(id: id)) }
    
    func fetchComments(postId: Int) async throws -> [Comment] { return try await provider.asyncRequest([Comment].self, .getComments(postId: postId)) }
    
    func createPost(post: Post) async throws -> Post { return try await provider.asyncRequest(Post.self, .createPost(post: post)) }
}
