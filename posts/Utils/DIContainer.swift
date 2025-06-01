//
//  DIContainer.swift
//  posts
//
//  Created by Heawon Seo on 6/1/25.
//

import Swinject

class DIContainer {
    
    static let shared = DIContainer()
    private let container: Container
    
    private init() {
        container = Container()
        configure()
    }
    
    private func configure() {
        container.register(PostRepository.self) { _ in
            return PostRepositoryImpl()
        }
        
        container.register(ImageRepository.self) { _ in
            return ImageRepositoryImpl()
        }
    }
    
    func getPostRepository() -> PostRepository {
        return container.resolve(PostRepository.self)!
    }
    
    func getImageRepository() -> ImageRepository {
        return container.resolve(ImageRepository.self)!
    }
}
