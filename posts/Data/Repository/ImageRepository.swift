//
//  ImageRepository.swift
//  posts
//
//  Created by Heawon Seo on 5/31/25.
//

import Foundation
import Kingfisher
import Combine
import UIKit

protocol ImageRepository {
    func fetchFromRemote(url: URL) -> AnyPublisher<UIImage, KingfisherError>
    func fetchFromCache(url: URL) -> AnyPublisher<UIImage?, KingfisherError>
}

class ImageRepositoryImpl: ImageRepository {
    
    private let mgr: KingfisherManager
    private let cache: ImageCache
    
    init() {
        mgr = KingfisherManager.shared
        cache = mgr.cache
        
        configureDiskCache()
        configureMemoryCache()
    }
    
    private func configureDiskCache() {
        cache.diskStorage.config.sizeLimit = 200 * 1024 * 1024 // 200 MB
        cache.diskStorage.config.expiration = .days(3) // 3 days after -> expired
    }
    
    private func configureMemoryCache() {
        cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024 // 50 MB
        cache.memoryStorage.config.expiration = .seconds(3600) // 1 hour after -> expired
        cache.memoryStorage.config.countLimit = 100 // Max file count: 100
    }
    
    func fetchFromRemote(url: URL) -> AnyPublisher<UIImage, KingfisherError> {
        return Future<UIImage, KingfisherError> { promise in
            self.mgr.retrieveImage(with: url) { result in
                switch result {
                case .success(let value):
                    promise(.success(value.image))
                    
                    print("Success: Get Image From Remote")
                    
                case .failure(let error):
                    promise(.failure(error))
                    
                    print("Fail: Get Image From Remote")
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchFromCache(url: URL) -> AnyPublisher<UIImage?, KingfisherError> {
        let cacheKey = url.absoluteString
        
        return Future<UIImage?, KingfisherError> { promise in
            self.cache.retrieveImage(forKey: cacheKey) { result in
                switch result {
                case .success(let value):
                    if let cachedImage = value.image {
                        promise(.success(cachedImage))
                        
                        print("Success: Get Image From Cache")
                        
                    } else {
                        promise(.success(nil))
                        
                        print("Fail: Get Image From Cache")
                    }
                    
                case .failure(let error):
                    promise(.failure(error))
                    
                    print("Fail: Get Image From Cache")
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    
}
