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
    
    @Published var path: [Post] = []
    @Published var posts: [Post] = []
    @Published var errorMsg: String?
    
    private var detailVM: DetailVM?
    
    private let getPostsService: GetPostsService
    private var cancellables = Set<AnyCancellable>()
    
    init(getPostsService: GetPostsService) {
        self.getPostsService = getPostsService
        print("ListVM init")
    }
    
    deinit {
        print("ListVM deinit")
    }
    
    func loadPosts() {
        errorMsg = ""
        
        getPostsService.execute()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMsg = error.getMsg()
                    break
                }
            } receiveValue: { [weak self] posts in
                self?.posts = posts
                self?.errorMsg = nil
            }
            .store(in: &cancellables)
    }
    
    func didTapPostRow(post: Post) {
        path.append(post)
    }
    
    func getDetailVM(post: Post) -> DetailVM {
        if let hasDetailVM = detailVM, hasDetailVM.post == post {
            return hasDetailVM
            
        } else {
            let detailVM = DetailVM(getFirstThreeCommentsService: GetFirstThreeCommentsServiceImpl(repository: PostRepositoryImpl()), post: post)
            self.detailVM = detailVM
            return detailVM
        }
    }
    
    
}
