//
//  ImageRepository.swift
//  posts
//
//  Created by Heawon Seo on 5/31/25.
//

import Foundation
import UIKit
import Kingfisher

protocol ImageRepository {
    func fetchImage(url: URL) async throws -> UIImage
}

final class DefaultImageRepository: ImageRepository {
    
    private let mgr: KingfisherManager
    
    init() {
        mgr = KingfisherManager.shared
        mgr.configCache()
    }
    
    func fetchImage(url: URL) async throws -> UIImage { return try await mgr.asyncRequestImage(url: url) }
    
}

extension KingfisherManager {
    
    func configCache() {
        configDiskCache()
        configMemoryCache()
    }
    
    func asyncRequestImage(url: URL) async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            cache.retrieveImage(forKey: url.absoluteString) { result in
                if case let .success(value) = result, let hasImage = value.image {
                    print("Success: Get Image From Cache")
                    continuation.resume(returning: hasImage)
                    return
                }
                
                print("Fail: Get Image From Cache. Trying remote...")
                
                self.retrieveImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        print("Success: Get Image From Remote")
                        continuation.resume(returning: value.image)
                        
                    case .failure(let error):
                        print("Fail: Get Image From Remote")
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    private func configDiskCache() {
        cache.diskStorage.config.sizeLimit = 200 * 1024 * 1024 // 200 MB
        cache.diskStorage.config.expiration = .days(3) // 3 days after -> expired
    }
    
    private func configMemoryCache() {
        cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024 // 50 MB
        cache.memoryStorage.config.expiration = .seconds(3600) // 1 hour after -> expired
        cache.memoryStorage.config.countLimit = 100 // Max file count: 100
    }
    
    
}
