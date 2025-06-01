//
//  CreatePostService.swift
//  posts
//
//  Created by Heawon Seo on 5/31/25.
//

import Foundation
import Combine

protocol CreatePostService {
    func execute(post: Post) -> AnyPublisher<Post, Error>
}

class CreatePostServiceImpl: CreatePostService {
    
    private let repository: PostRepository
    
    init(repository: PostRepository) { self.repository = repository }
    
    func execute(post: Post) -> AnyPublisher<Post, Error> { return repository.createPost(post: post) }
}
