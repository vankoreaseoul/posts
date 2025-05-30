//
//  GetFirstThreeCommentsService.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation
import Combine

protocol GetFirstThreeCommentsService {
    func execute(postId: Int) -> AnyPublisher<[Comment], Error>
}

class GetFirstThreeCommentsServiceImpl: GetFirstThreeCommentsService {
    
    private let repository: PostRepository
    
    init(repository: PostRepository) { self.repository = repository }
    
    func execute(postId: Int) -> AnyPublisher<[Comment], Error> {
        return repository.fetchComments(postId: postId)
            .tryMap { comments in
                let commentList = comments.sorted { $0.id < $1.id }
                return Array(commentList.prefix(3))
            }
            .eraseToAnyPublisher()
    }
    
    
}
