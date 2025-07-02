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

@Observable
final class ListVM {
    
    var phase: ViewPhase<[Post]> = .IDLE
    var isRefreshBtnTapped: Bool = false { didSet { didTapRefreshBtn() } }
    
    @ObservationIgnored var isPostsFetched: Bool = false
    @ObservationIgnored var posts: [Post] = []
    @ObservationIgnored var refreshTask: Task<Void, Never>?
    
    @ObservationIgnored private let getPostsService: GetPostsService
    @ObservationIgnored weak var coordinator: Navigator?
    
    init(getPostsService: GetPostsService, coordinator: Navigator) {
        print("ListVM init")
        self.getPostsService = getPostsService
        self.coordinator = coordinator
    }
    
    deinit {
        print("ListVM deinit")
        refreshTask?.cancel()
    }
    
    func fetchPosts() async {
        print("fetchPosts call...")

        await MainActor.run { phase = .LOADING }
        defer { if !isPostsFetched { isPostsFetched.toggle() } }
        
        do {
            let fetchedPosts = try await Array( getPostsService.execute().reversed() )
            posts = fetchedPosts
            
            await MainActor.run { phase = .LOADED(posts) }
                    
        } catch {
            await MainActor.run { phase = .FAILED(error.localizedDescription) }
        }
    }
    
    @MainActor
    func didTapCreateBtn() { coordinator?.push(.CREATE) }
    
    @MainActor
    func didTapListRow(postId: Int) { coordinator?.push(.DETAIL(postId)) }
    
    private func didTapRefreshBtn() {
        refreshTask?.cancel()
        refreshTask = Task {
            defer {  refreshTask = nil }
            await fetchPosts()
        }
    }
    
}
