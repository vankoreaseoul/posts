//
//  ListVM.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation

@MainActor
@Observable
final class ListVM {
    
    var navigationPath: [Int] = []
    
    var posts: [Post] = []
    var isLoading: Bool = false
    var errorMsg: String?
    
    private let getPostsService: GetPostsService
    
    init(getPostsService: GetPostsService) {
        print("ListVM init")
        self.getPostsService = getPostsService
    }
    
    deinit {
        print("ListVM deinit")
    }
    
    func fetchPosts() async {
        print("fetchPosts call...")
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            posts = try await getPostsService.execute().reversed()
                    
        } catch {
            errorMsg = error.localizedDescription
        }
    }
    
    func didTapAlertOkBtn() { errorMsg = nil }
    
    func didTapCreateBtn() { navigationPath.append(0) }
    
    
}
