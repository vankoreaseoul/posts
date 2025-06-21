//
//  DetailVM.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation

@Observable
final class DetailVM {
    
    let postId: Int
    
    var post: Post?
    var isLoading: Bool = false
    var errorMsg: String?
    var comments: [Comment] = []
    var totalComments: [Comment] = []

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
        
        do {
            // TODO: 순차 진행 -> 병렬 X
            let fetchedPost = try await getPostDetailService.getPost(id: postId)
            let fetchedComments = try await getPostDetailService.getComments(postId: postId)
            
            await MainActor.run {
                post = fetchedPost
                totalComments = fetchedComments
                comments = Array(totalComments.prefix(3))
                isLoading = false
            }
            
        } catch {
            await MainActor.run {
                errorMsg = error.localizedDescription
                isLoading = false
            }
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
