//
//  DetailVM.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation
import Combine

class DetailVM: ObservableObject {
    
    @Published var comments: [Comment] = []
    @Published var errorMsg: String?
    
    let post: Post
    
    private let getFirstThreeCommentsService: GetFirstThreeCommentsService
    private var cancellables = Set<AnyCancellable>()
    
    init(getFirstThreeCommentsService: GetFirstThreeCommentsService, post: Post) {
        self.getFirstThreeCommentsService = getFirstThreeCommentsService
        self.post = post
        
        print("DetailVM \(post.id) init")
    }
    
    deinit {
        print("DetailVM \(post.id) deinit")
    }
    
    func loadComments() {
        errorMsg = ""
        
        getFirstThreeCommentsService.execute(postId: post.id)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMsg = error.getMsg()
                    break
                }
            } receiveValue: { [weak self] comments in
                self?.comments = comments
                self?.errorMsg = nil
            }
            .store(in: &cancellables)
    }
}
