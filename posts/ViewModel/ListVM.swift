//
//  ListVM.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation

@Observable
final class ListVM {
    
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
        
        do {
            let fetchedPosts = try await getPostsService.execute()
            
            await MainActor.run {
                posts = fetchedPosts
                isLoading = false
            }
            
        } catch {
            // TODO: error메시지 변환...
            await MainActor.run {
                errorMsg = error.localizedDescription
                isLoading = false
            }
            
        }
    }
    
    func didTapAlertOkBtn() { errorMsg = nil }
    
    
    
     
//    func didTapCreateBtn() {
//        path.append(.CREATE)
//    }
//    
//    func getCreateVM() -> CreateVM {
//        if let hasCreateVM = createVM {
//            return hasCreateVM
//            
//        } else {
//            let createVM = CreateVM(createPostService: CreatePostServiceImpl(repository: DIContainer.shared.getPostRepository()))
//            self.createVM = createVM
//            return createVM
//        }
//    }
    
    
}
