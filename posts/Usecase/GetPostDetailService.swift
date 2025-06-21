//
//  GetPostDetail.swift
//  posts
//
//  Created by Heawon Seo on 6/18/25.
//

import Foundation

final class GetPostDetailService {
    
    private let repository: PostRepository
    
    init(repository: PostRepository) { self.repository = repository }
    
    func getPost(id: Int) async throws -> Post { return try await repository.fetchPostDetail(id: id) }
    
    func getComments(postId: Int) async throws -> [Comment] { return try await repository.fetchComments(postId: postId) }
}
