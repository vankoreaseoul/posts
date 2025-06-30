//
//  ListVM.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation

enum ViewPhase<T: Equatable>: Equatable {
    case IDLE
    case LOADING
    case LOADED(T)
    case FAILED(String)
}

@MainActor
@Observable
final class ListVM {
    
    var navigationPath: [Int] = []
    var phase: ViewPhase<[Post]> = .IDLE
    
    var isSpinnerViewPresented: Bool = false
    @ObservationIgnored var posts: [Post] = []
    
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

        phase = .LOADING
        
        do {
            let posts = try await Array( getPostsService.execute().reversed() )
            self.posts = posts
            phase = .LOADED(posts)
                    
        } catch {
            phase = .FAILED(error.localizedDescription)
        }
    }
    
    func didTapCreateBtn() { navigationPath.append(0) }
    
}
