//
//  GetPostsService.swift
//  posts
//
//  Created by Heawon Seo on 5/28/25.
//

import Foundation
import Combine

protocol GetPostsService {
    func execute() -> AnyPublisher<[Post], Error>
}

class GetPostsServiceImpl: GetPostsService {
    
    private let repository: PostRepository
    
    init(repository: PostRepository) { self.repository = repository }
    
    func execute() -> AnyPublisher<[Post], Error> { return repository.fetchPosts() }
}
