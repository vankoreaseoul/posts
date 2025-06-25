//
//  CreateVM.swift
//  posts
//
//  Created by Heawon Seo on 5/31/25.
//

import Foundation
import UIKit

enum CreatePostState: Equatable {
    
    static func == (lhs: CreatePostState, rhs: CreatePostState) -> Bool {
        if case .FAILURE = lhs, case .FAILURE = rhs {
            return true
        } else if case .SUCCESS = lhs, case .SUCCESS = rhs {
            return true
        } else {
            return false
        }
    }
    
    case SUCCESS(msg: String)
    case FAILURE(msg: String)
}

@MainActor
@Observable
final class CreateVM {
    
    var title: String = ""
    var body: String = ""
    
    var newPost: Post?
    var isLoading: Bool = false
    var createState: CreatePostState?
    
    private let createPostService: CreatePostService
    
    init(createPostService: CreatePostService) {
        print("CreateVM init")
        self.createPostService = createPostService
    }
    
    deinit {
        print("CreateVM deinit")
    }
    
    func didTapBackground() {
        UIApplication.shared.hideKeyboard()
    }
    
    func didTapPostBtn() {
        // Suppose a user logs in and his/her id is 1
        newPost = Post(id: 0, title: title, body: body, userId: 1)
    }
    
    func saveNewPost() async {
        print("saveNewPost call")
        
        guard let hasPost = newPost, hasPost.id == .zero else { return }
        
        print("saveNewPost proceed")
        
        isLoading = true
        defer { isLoading = false }

        do {
            newPost = try await createPostService.execute(post: hasPost)
            createState = .SUCCESS(msg: "Successfully created a post!")
        } catch {
            createState = .FAILURE(msg: error.localizedDescription)
        }
    }
    
}
