//
//  ImageView.swift
//  posts
//
//  Created by Heawon Seo on 5/30/25.
//

import SwiftUI

struct ImageView: View {
    
    @StateObject var vm = ImageVM(getImageService: GetImageServiceImpl(repository: DIContainer.shared.getImageRepository()))
    let postId: Int
    
    init(postId: Int) {
        self.postId = postId
        
        print("ImageView init")
    }
    
    var body: some View {
        
        Rectangle()
            .fill(.black.opacity(0.2))
            .frame(width: 200, height: 300)
            .overlay {
                if let hasErrorMsg = vm.errorMsg {
                    if hasErrorMsg.isEmpty {
                        SpinnerView()
                        
                    } else {
                        Text(hasErrorMsg)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    
                } else {
                    if let hasImage = vm.image {
                        Image(uiImage: hasImage)
                    }
                }
            }
        
            .onAppear {
                vm.fetchImage(postId: postId)
                
                print("ImageView Appeard")
            }
        
    }
}

#Preview {
    ImageView(postId: 1)
}
