//
//  ListVM.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation
import Combine
import Moya

class ListVM: ObservableObject {
    
    @Published var path: [Int] = []
    @Published var posts: [Post] = []
    
    @Published var topViewType: TopViewType?
    var errorMsg: String = ""
    
    private let getPostsService: GetPostsService
    private var cancellables = Set<AnyCancellable>()
    
    init(getPostsService: GetPostsService) { self.getPostsService = getPostsService }
    
    func loadPosts() {
        topViewType = .SPINNER
        
        getPostsService.execute()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMsg = error.getMsg()
                    self?.topViewType = .ALERT
                    break
                }
            } receiveValue: { [weak self] posts in
                self?.posts = posts
                self?.topViewType = nil
            }
            .store(in: &cancellables)
    }
    
    
    
}
