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
}

class PostRepositoryImpl: PostRepository {
    
    private let provider = MoyaProvider<PostAPI>()
    
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        return provider.requestPublisher(.getPosts)
            .tryMap { try $0.map([Post].self) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
}
