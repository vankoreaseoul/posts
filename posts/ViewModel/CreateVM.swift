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
    
    @MainActor
    func didTapBackground() { hideKeyboard() }
    
    func didTapPostBtn() {
        hideKeyboard()
        coordinator?.presentFullScreenCover(.LOADING)
        
        // Suppose: User(id: 1)
        let post = Post(id: 0, title: title, body: body, userId: 1)
        
        createPostTask?.cancel()
        createPostTask = Task {
            defer {
                coordinator?.dismissCover()
                createPostTask = nil
            }
            
            do {
                let newPost = try await createPostService.execute(post: post)
                await MainActor.run { coordinator?.presentAlert(.DONE(newPost)) }
                
            } catch {
                await MainActor.run { coordinator?.presentAlert(.ERROR(error.localizedDescription)) }
            }
        }
    }
    
}
