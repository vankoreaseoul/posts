//
//  GetImageService.swift
//  posts
//
//  Created by Heawon Seo on 5/31/25.
//

import Foundation
import Kingfisher
import Combine
import UIKit

protocol GetImageService {
    func execute(url: URL) -> AnyPublisher<UIImage, KingfisherError>
}

class GetImageServiceImpl: GetImageService {
    
    private let repository: ImageRepository
    
    init(repository: ImageRepository) { self.repository = repository }
    
    func execute(url: URL) -> AnyPublisher<UIImage, KingfisherError> {
        repository.fetchFromCache(url: url)
            .catch { error in
                return Just(nil)
                    .setFailureType(to: KingfisherError.self)
            }
            .flatMap { cachedImage -> AnyPublisher<UIImage, KingfisherError> in
                if let image = cachedImage {
                    return Just(image)
                        .setFailureType(to: KingfisherError.self)
                        .eraseToAnyPublisher()
                    
                } else {
                    return self.repository.fetchFromRemote(url: url)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
}
