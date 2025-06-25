//
//  DetailVM.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation
import UIKit

enum ImageState {
    case SUCCESS(image: UIImage)
    case FAILURE(msg: String)
    case LOADING
}

extension ImageState {
    var isFailure: Bool {
        guard case .FAILURE = self else { return false }
        return true
    }
}

@MainActor
@Observable
final class DetailVM {
    
    let postId: Int
    
    var post: Post?
    var isLoading: Bool = false
    var errorMsg: String?
    var comments: [Comment] = []
    var totalComments: [Comment] = []
    
    var imageState: ImageState = .LOADING
    var imageWidth: Int = .zero
    
    private let getPostDetailService: GetPostDetailService

    init(postId: Int, getPostDetailService: GetPostDetailService) {
        print("DetailVM \(postId) init")
        self.postId = postId
        self.getPostDetailService = getPostDetailService
    }
    
    deinit {
        print("DetailVM \(postId) deinit")
    }
    
    func fetchPostDetail() async {
        print("fetchPost call")
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            // 병렬처리
            async let fetchedPost = getPostDetailService.getPost(id: postId)
            async let fetchedComments = getPostDetailService.getComments(postId: postId)
            
            // 포스트에서만 에러 처리
            post = try await fetchedPost
            
            // 댓글 에러는 무시 -> 댓글을 못 읽어도 포스트는 보이게 한다.
            if let hasComments = try? await fetchedComments {
                totalComments = hasComments
                comments = Array(totalComments.prefix(3))
            }
            
        } catch {
            errorMsg = error.localizedDescription
        }
    }
    
    func fetchImage() async {
        print("fetchImage call...")
        
        guard imageWidth > 0 else { return }
        
        print("imageWidth = \(imageWidth)")
        
        do {
            let fetchedImage = try await getPostDetailService.getImage(url: URL(string: "\(IMAGE_URL)/\(postId)/\(imageWidth)")!)
            imageState = .SUCCESS(image: fetchedImage)
            
        } catch {
            imageState = .FAILURE(msg: error.localizedDescription)
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
