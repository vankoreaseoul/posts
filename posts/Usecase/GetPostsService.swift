//
//  GetPostsService.swift
//  posts
//
//  Created by Heawon Seo on 5/28/25.
//

final class GetPostsService {
    
    private let repository: PostRepository
    
    init(repository: PostRepository) { self.repository = repository }
    
    func execute() async throws -> [Post] { return try await repository.fetchPosts() }
}
