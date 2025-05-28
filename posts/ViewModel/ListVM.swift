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
    
    @Published var posts: [Post] = []
    @Published var errorMsg: String?
    
    private let getPostsService: GetPostsService
    private var cancellables = Set<AnyCancellable>()
    
    init(getPostsService: GetPostsService) { self.getPostsService = getPostsService }
    
    
    func loadPosts() {
        getPostsService.execute()
            .sink { completion in
                switch completion {
                case .finished:
                    print("done")
                    break
                case .failure(let error):
                    guard let moyaError = error as? MoyaError else {
                        print("error = \(error)")
                        return
                    }
                    print("moyaError = \(moyaError)")
                    break
                }
            } receiveValue: { posts in
                print("posts = \(posts)")
            }
            .store(in: &cancellables)

    }
}
