//
//  ListVM.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation
import Combine
import Moya

enum ViewType {
    case DETAIL, CREATE
}

class ListVM: ObservableObject {
    
    @Published var path: [ViewType] = []
    @Published var posts: [Post] = []
    @Published var errorMsg: String?
    
    private var selectedPost: Post?
    var detailVM: DetailVM?
    
    var createVM: CreateVM?
    
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
                let postList = posts.sorted { $0.id > $1.id }
                self?.posts = postList
                self?.errorMsg = nil
            }
            .store(in: &cancellables)
    }
    
    func didTapPostRow(post: Post) {
        selectedPost = post
        path.append(.DETAIL)
    }
    
    func getDetailVM() -> DetailVM {
        let post: Post = selectedPost ?? Post(id: 0, title: "", body: "", userId: 0)
        
        if let hasDetailVM = detailVM, hasDetailVM.post == post {
            return hasDetailVM
            
        } else {
            let detailVM = DetailVM(getFirstThreeCommentsService: GetFirstThreeCommentsServiceImpl(repository: DIContainer.shared.getPostRepository()), post: post)
            self.detailVM = detailVM
            return detailVM
        }
    }
    
    func didTapCreateBtn() {
        path.append(.CREATE)
    }
    
    func getCreateVM() -> CreateVM {
        if let hasCreateVM = createVM {
            return hasCreateVM
            
        } else {
            let createVM = CreateVM(createPostService: CreatePostServiceImpl(repository: DIContainer.shared.getPostRepository()))
            self.createVM = createVM
            return createVM
        }
    }
    
    
}
