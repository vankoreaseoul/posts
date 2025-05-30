//
//  ImageVM.swift
//  posts
//
//  Created by Heawon Seo on 5/30/25.
//

import Foundation
import Combine
import UIKit

class ImageVM: ObservableObject {
    
    @Published var errorMsg: String?
    @Published var image: UIImage?
    
    private let getImageService: GetImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(getImageService: GetImageService) {
        self.getImageService = getImageService
        
        print("ImageVM init")
    }
    
    deinit {
        print("ImageVM deinit")
    }
    
    func fetchImage(postId: Int) {
        errorMsg = ""
        
        let urlStr = "\(IMAGE_URL)/\(postId)/200/300"
        
        guard let url = URL(string: urlStr) else {
            errorMsg = "URL Error"
            return
        }
        
        getImageService.execute(url: url)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMsg = "Kingfisher Error"
                    
                    print("error = \(error)")
                    break
                }
            } receiveValue: { [weak self] uiImage in
                self?.image = uiImage
                self?.errorMsg = nil
            }
            .store(in: &cancellables)
    }
    
    
}
