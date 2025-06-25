//
//  GetPostDetail.swift
//  posts
//
//  Created by Heawon Seo on 6/18/25.
//

import UIKit

final class GetPostDetailService {
    
    private let postRepository: PostRepository
    private let imageRepository: ImageRepository
    
    init(postRepository: PostRepository, imageRepository: ImageRepository) {
        self.postRepository = postRepository
        self.imageRepository = imageRepository
    }
    
    func getPost(id: Int) async throws -> Post { return try await postRepository.fetchPost(id: id) }
    
    func getComments(postId: Int) async throws -> [Comment] { return try await postRepository.fetchComments(postId: postId) }
    
    func getImage(url: URL) async throws -> UIImage { return try await imageRepository.fetchImage(url: url) }
}
