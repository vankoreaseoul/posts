//
//  DetailVM.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation
import UIKit

@MainActor
@Observable
final class DetailVM {
    
    @ObservationIgnored let postId: Int
    
    var phase: ViewPhase<Post> = .IDLE
    var comments: [Comment] = []
    var totalComments: [Comment] = []
    
    var imagePhase: ViewPhase<UIImage> = .IDLE
    @ObservationIgnored var imageWidth: Int = .zero {
        didSet { task = Task { await fetchImage() } }
    }
    @ObservationIgnored private var task: Task<Void, Never>?
    
    private let getPostDetailService: GetPostDetailService

    init(postId: Int, getPostDetailService: GetPostDetailService) {
        print("DetailVM \(postId) init")
        self.postId = postId
        self.getPostDetailService = getPostDetailService
    }
    
    deinit {
        print("DetailVM \(postId) deinit")
        task?.cancel()
    }
    
    func fetchPostDetail() async {
        print("fetchPost call")
        
        phase = .LOADING
        
        do {
            // 병렬처리
            async let fetchedPost = getPostDetailService.getPost(id: postId)
            async let fetchedComments = getPostDetailService.getComments(postId: postId)
            
            // 포스트에서만 에러 처리
            let post = try await fetchedPost
            
            // 댓글 에러는 무시 -> 댓글을 못 읽어도 포스트는 보이게 한다.
            if let hasComments = try? await fetchedComments {
                totalComments = hasComments
                comments = Array(totalComments.prefix(3))
            }
            
            phase = .LOADED(post)
            
        } catch {
            phase = .FAILED(error.localizedDescription)
        }
    }
    
    func fetchImage() async {
        print("fetchImage call...")
        
        guard imageWidth > 0 else { return }
        
        print("imageWidth = \(imageWidth)")
        
        do {
            let fetchedImage = try await getPostDetailService.getImage(url: URL(string: "\(IMAGE_URL)/\(postId)/\(imageWidth)")!)
            imagePhase = .LOADED(fetchedImage)
            
        } catch {
            imagePhase = .FAILED(error.localizedDescription)
        }
    }
    
    func didTapCommentsMoreBtn() {
        if comments.count == 3 {
            comments = totalComments
        } else {
            comments = Array(totalComments.prefix(3))
        }
    }
    
}
