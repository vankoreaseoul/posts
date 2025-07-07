//
//  CreateVM.swift
//  posts
//
//  Created by Heawon Seo on 5/31/25.
//

import Foundation
import UIKit

@Observable
final class CreateVM {
    
    var title: String = ""
    var body: String = ""
    @ObservationIgnored private var createPostTask: Task<Void, Never>?
    
    @ObservationIgnored private let createPostService: CreatePostService
    @ObservationIgnored weak var coordinator: Navigator?
    
    init(createPostService: CreatePostService, coordinator: Navigator) {
        print("CreateVM init")
        self.createPostService = createPostService
        self.coordinator = coordinator
    }
    
    deinit {
        print("CreateVM deinit")
        createPostTask?.cancel()
    }
    
    func didTapBackground() { hideKeyboard() }
    
    func didTapPostBtn() {
        hideKeyboard()
        coordinator?.presentFullScreenCover(.LOADING)
        
        // Suppose: User(id: 1)
        let post = Post(id: 0, title: title, body: body, userId: 1)
        
        createPostTask?.cancel()
        createPostTask = Task { [weak self, createPostService] in
            do {
                // 풀커버이기 때문에, 중간에 뷰에서 이탈할 수 없음 -> task.cancel 고려 X
                let newPost = try await createPostService.execute(post: post)
                self?.coordinator?.presentAlert(.DONE(newPost))
                
            } catch {
                self?.coordinator?.presentAlert(.ERROR(error.localizedDescription))
            }
            
            self?.coordinator?.dismissCover()
            self?.createPostTask = nil
        }
    }
    
}
