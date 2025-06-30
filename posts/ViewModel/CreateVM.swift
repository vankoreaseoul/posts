//
//  CreateVM.swift
//  posts
//
//  Created by Heawon Seo on 5/31/25.
//

import Foundation
import UIKit

@MainActor
@Observable
final class CreateVM {
    
    var title: String = ""
    var body: String = ""
    
    var phase: ViewPhase<Post> = .IDLE
    var alertMsg: String = ""
    
    @ObservationIgnored private var task: Task<Void, Never>?
    
    private let createPostService: CreatePostService
    
    init(createPostService: CreatePostService) {
        print("CreateVM init")
        self.createPostService = createPostService
    }
    
    deinit {
        print("CreateVM deinit")
        task?.cancel()
    }
    
    func didTapBackground() {
        UIApplication.shared.hideKeyboard()
    }
    
    func didTapPostBtn() {
        task = Task { await saveNewPost() }
    }
    
    func saveNewPost() async {
        print("saveNewPost call")
        
        phase = .LOADING
        
        // Suppose a user logs in and his/her id is 1
        let post = Post(id: 0, title: title, body: body, userId: 1)

        do {
            let newPost = try await createPostService.execute(post: post)
            phase = .LOADED(newPost)

        } catch {
            phase = .FAILED(error.localizedDescription)
        }
    }
    
    func didTapAlertOkBtn() { alertMsg = "" }
    
}
