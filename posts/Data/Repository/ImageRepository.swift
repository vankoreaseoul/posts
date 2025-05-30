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
