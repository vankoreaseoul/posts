//
//  DetailVM.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation
import UIKit

@Observable
final class DetailVM {
    
    @ObservationIgnored let postId: Int
    
    var phase: ViewPhase<Post> = .IDLE
    var comments: [Comment] = []
    var totalComments: [Comment] = []
    var imagePhase: ViewPhase<UIImage> = .IDLE
    
    @ObservationIgnored var imageWidth: Int = .zero {
        didSet {
            fetchImageTask?.cancel()
            fetchImageTask = Task {
                defer { fetchImageTask = nil }
                await fetchImage()
            }
        }
    }
    @ObservationIgnored private var fetchImageTask: Task<Void, Never>?
    
    @ObservationIgnored private let getPostDetailService: GetPostDetailService

    init(postId: Int, getPostDetailService: GetPostDetailService) {
        print("DetailVM \(postId) init")
        self.postId = postId
        self.getPostDetailService = getPostDetailService
    }
    
    deinit {
        print("DetailVM \(postId) deinit")
        fetchImageTask?.cancel()
    }
    
    func fetchPostDetail() async {
        print("fetchPost call")
        
        await MainActor.run { phase = .LOADING }
        
        do {
            // 병렬처리
            async let fetchedPost = getPostDetailService.getPost(id: postId)
            async let fetchedComments = getPostDetailService.getComments(postId: postId)
            
            // 포스트에서만 에러 처리
            let post = try await fetchedPost
            
            // 댓글 에러는 무시 -> 댓글을 못 읽어도 포스트는 보이게 한다.
            if let hasComments = try? await fetchedComments {
                await MainActor.run {
                    totalComments = hasComments
                    comments = Array(totalComments.prefix(3))
                }
            }
            
            await MainActor.run { phase = .LOADED(post) }
            
        } catch {
            await MainActor.run { phase = .FAILED(error.localizedDescription) }
        }
    }
    
    private func fetchImage() async {
        print("fetchImage call...")
        
        guard imageWidth > 0 else { return }
        
        print("imageWidth = \(imageWidth)")
        
        await MainActor.run { imagePhase = .LOADING }
        
        do {
            let fetchedImage = try await getPostDetailService.getImage(url: URL(string: "\(IMAGE_URL)/\(postId)/\(imageWidth)")!)
            await MainActor.run { imagePhase = .LOADED(fetchedImage) }
            
        } catch {
            await MainActor.run { imagePhase = .FAILED(error.localizedDescription) }
        }
    }
    
    @MainActor
    func didTapCommentsMoreBtn() {
        if comments.count == 3 {
            comments = totalComments
        } else {
            comments = Array(totalComments.prefix(3))
        }
    }
    
}
