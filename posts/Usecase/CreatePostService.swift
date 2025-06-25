//
//  CreatePostService.swift
//  posts
//
//  Created by Heawon Seo on 5/31/25.
//

final class CreatePostService {
    
    private let repository: PostRepository
    
    init(repository: PostRepository) { self.repository = repository }
    
    func execute(post: Post) async throws -> Post { return try await repository.createPost(post: post) }
}
