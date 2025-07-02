//
//  Assembly.swift
//  posts
//
//  Created by Heawon Seo on 7/1/25.
//

import Swinject

class ListViewModelAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(PostRepository.self) { _ in
            return DefaultPostRepository()
        }
        
        container.register(GetPostsService.self) { resolver in
            let postRepo = resolver.resolve(PostRepository.self)!
            return GetPostsService(repository: postRepo)
        }
        
        container.register(ListVM.self) { (resolver, coordinator: Navigator) in
            let getPostService = resolver.resolve(GetPostsService.self)!
            return ListVM(getPostsService: getPostService, coordinator: coordinator)
        }
        .inObjectScope(.container)
    }
}

class DetailViewModelAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(ImageRepository.self) { _ in
            return DefaultImageRepository()
        }
        
        container.register(GetPostDetailService.self) { resolver in
            let postRepo = resolver.resolve(PostRepository.self)!
            let imageRepo = resolver.resolve(ImageRepository.self)!
            return GetPostDetailService(postRepository: postRepo, imageRepository: imageRepo)
        }
        
        container.register(DetailVM.self) { (resolver, postId: Int) in
            let getPostDetailService = resolver.resolve(GetPostDetailService.self)!
            return DetailVM(postId: postId, getPostDetailService: getPostDetailService)
        }
    }
}

class CreateViewModelAssembly: Assembly {
    
    func assemble(container: Swinject.Container) {
        container.register(CreatePostService.self) { resolver in
            let postRepo = resolver.resolve(PostRepository.self)!
            return CreatePostService(repository: postRepo)
        }
        
        container.register(CreateVM.self) { (resolver, coordinator: Navigator) in
            let createPostService = resolver.resolve(CreatePostService.self)!
            return CreateVM(createPostService: createPostService, coordinator: coordinator)
        }
    }
}
