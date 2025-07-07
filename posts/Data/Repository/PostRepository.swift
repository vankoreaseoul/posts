//
//  PostRepository.swift
//  posts
//
//  Created by Heawon Seo on 5/28/25.
//

import Foundation
import Moya

protocol PostRepository {
    func fetchPosts(isCancellable: Bool) async throws -> [Post]
    func fetchPost(id: Int, isCancellable: Bool) async throws -> Post
    func fetchComments(postId: Int, isCancellable: Bool) async throws -> [Comment]
    func createPost(post: Post, isCancellable: Bool) async throws -> Post
}

final class DefaultPostRepository: PostRepository {
    
    private let provider: MoyaProvider<PostAPI>
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        let session = Session(configuration: config)
        provider = MoyaProvider<PostAPI>(session: session)
    }
    
    func fetchPosts(isCancellable: Bool = false) async throws -> [Post] {
        if isCancellable {
            return try await provider.asyncCancellableRequest([Post].self, .getPosts)
        } else {
            return try await provider.asyncRequest([Post].self, .getPosts)
        }
    }
    
    func fetchPost(id: Int, isCancellable: Bool = false) async throws -> Post {
        if isCancellable {
            return try await provider.asyncCancellableRequest(Post.self, .getPost(id: id))
        } else {
            return try await provider.asyncRequest(Post.self, .getPost(id: id))
        }
    }
    
    func fetchComments(postId: Int, isCancellable: Bool = false) async throws -> [Comment] {
        if isCancellable {
            return try await provider.asyncCancellableRequest([Comment].self, .getComments(postId: postId))
        } else {
            return try await provider.asyncRequest([Comment].self, .getComments(postId: postId))
        }
    }
    
    func createPost(post: Post, isCancellable: Bool = false) async throws -> Post {
        if isCancellable {
            return try await provider.asyncCancellableRequest(Post.self, .createPost(post: post))
        } else {
            return try await provider.asyncRequest(Post.self, .createPost(post: post))
        }
    }
    
}
