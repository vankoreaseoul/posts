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
    
    func getPost(id: Int, isCancellable: Bool = false) async throws -> Post { return try await postRepository.fetchPost(id: id, isCancellable: isCancellable) }
    
    func getComments(postId: Int, isCancellable: Bool = false) async throws -> [Comment] { return try await postRepository.fetchComments(postId: postId, isCancellable: isCancellable) }
    
    func getImage(url: URL, isCancellable: Bool = false) async throws -> UIImage { return try await imageRepository.fetchImage(url: url, isCancellable: isCancellable) }
}
