//
//  PostRepository.swift
//  posts
//
//  Created by Heawon Seo on 5/28/25.
//

import Foundation
import Moya

import CombineMoya
import Combine

protocol PostRepository {
    func fetchPosts() async throws -> [Post]
    func fetchPostDetail(id: Int) async throws -> Post
    func fetchComments(postId: Int) async throws -> [Comment]
    
    func createPost(post: Post) -> AnyPublisher<Post, Error>
}

final class DefaultPostRepository: PostRepository {
    private let provider = MoyaProvider<PostAPI>()
    
    func fetchPosts() async throws -> [Post] { return try await provider.asyncRequest([Post].self, .getPosts) }
    
    func fetchPostDetail(id: Int) async throws -> Post { return try await provider.asyncRequest(Post.self, .getPost(id: id)) }
    
    func fetchComments(postId: Int) async throws -> [Comment] { return try await provider.asyncRequest([Comment].self, .getComments(postId: postId)) }
    
    
    
    func createPost(post: Post) -> AnyPublisher<Post, Error> {
        return provider.requestPublisher(.createPost(post: post))
            .tryMap { try $0.map(Post.self) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
