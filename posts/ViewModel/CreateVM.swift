//
//  CreateVM.swift
//  posts
//
//  Created by Heawon Seo on 5/31/25.
//

import Foundation
import Combine

class CreateVM: ObservableObject {
    
    @Published var title: String = ""
    @Published var body: String = ""
    @Published var newPost: Post?
    @Published var errorMsg: String?
    
    private let createPostService: CreatePostService
    private var cancellables = Set<AnyCancellable>()
    
    init(createPostService: CreatePostService) {
        self.createPostService = createPostService
        
        print("CreateVM init")
    }
    
    deinit {
        print("CreateVM deinit")
    }
    
    func didTapPostBtn() {
        errorMsg = ""
        
        let post = Post(id: 0, title: title, body: body, userId: 1)
        
        createPostService.execute(post: post)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMsg = error.getMsg()
                    break
                }
            } receiveValue: { [weak self] post in
                self?.newPost = post
                self?.errorMsg = nil
            }
            .store(in: &cancellables)
    }
}
