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
    func fetchPosts() -> AnyPublisher<[Post], Error>
    func fetchComments(postId: Int) -> AnyPublisher<[Comment], Error>
    func createPost(post: Post) -> AnyPublisher<Post, Error>
}

class PostRepositoryImpl: PostRepository {
   
    private let provider = MoyaProvider<PostAPI>()
    
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        return provider.requestPublisher(.getPosts)
            .tryMap { try $0.map([Post].self) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchComments(postId: Int) -> AnyPublisher<[Comment], Error> {
        return provider.requestPublisher(.getComments(postId: postId))
            .tryMap { try $0.map([Comment].self) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func createPost(post: Post) -> AnyPublisher<Post, Error> {
        return provider.requestPublisher(.createPost(post: post))
            .tryMap { try $0.map(Post.self) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
