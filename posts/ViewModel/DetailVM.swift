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
    
    @ObservationIgnored var imageWidth: Int = .zero { didSet { fetchImage() } }
    @ObservationIgnored private var fetchPostTask: Task<Void, Never>?
    @ObservationIgnored private var fetchImageTask: Task<Void, Never>?
    
    @ObservationIgnored private let getPostDetailService: GetPostDetailService
    

    init(postId: Int, getPostDetailService: GetPostDetailService) {
        print("DetailVM \(postId) init")
        self.postId = postId
        self.getPostDetailService = getPostDetailService
    }
    
    deinit {
        print("DetailVM \(postId) deinit")
        fetchPostTask?.cancel()
        fetchImageTask?.cancel()
    }
    
    func fetchPostDetail() {
        print("fetchPostDetail call..")
        fetchPostTask?.cancel()
        
        fetchPostTask = Task { [weak self, getPostDetailService, postId] in
            self?.phase = .LOADING
            
            do {
                // 병렬호출: UI 속도 개선 - 1, 2
                try cancelIfNeeded()
                async let fetchedPost = getPostDetailService.getPost(id: postId, isCancellable: true)    // - 1
                try cancelIfNeeded()
                async let fetchedComments = getPostDetailService.getComments(postId: postId, isCancellable: true)    // - 2
                
                try cancelIfNeeded()
                // 포스트에서만 에러 처리
                let post = try await fetchedPost
                
                try cancelIfNeeded()
                // 댓글 에러는 무시 -> 댓글을 못 읽어도 포스트는 보이게 한다.
                if let hasComments = try? await fetchedComments {
                    self?.totalComments = hasComments
                    self?.comments = Array(hasComments.prefix(3))
                }
                
                try cancelIfNeeded()
                self?.phase = .LOADED(post)
                
            } catch {
                if let postError = error as? PostError, case .CANCEL_REQUEST = postError { return }
                self?.phase = .FAILED(error.localizedDescription)
            }
            
            self?.fetchPostTask = nil
        }
    }
    
    private func fetchImage() {
        print("fetchImage call...")
        fetchImageTask?.cancel()
        
        fetchImageTask = Task { [weak self, imageWidth, getPostDetailService, postId] in
            guard imageWidth > 0 else { return }
            
            print("imageWidth = \(imageWidth)")
            
            self?.imagePhase = .LOADING
            
            do {
                try cancelIfNeeded()
                let fetchedImage = try await getPostDetailService.getImage(url: URL(string: "\(IMAGE_URL)/\(postId)/\(imageWidth)")!, isCancellable: true)
                
                try cancelIfNeeded()
                self?.imagePhase = .LOADED(fetchedImage)
                
            } catch {
                if let postError = error as? PostError, case .CANCEL_REQUEST = postError { return }
                self?.imagePhase = .FAILED(error.localizedDescription)
            }
            
            self?.fetchImageTask = nil
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
