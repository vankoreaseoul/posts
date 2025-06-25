//
//  ImageView.swift
//  posts
//
//  Created by Heawon Seo on 5/30/25.
//

import SwiftUI

struct ImageView: View {
    
    @Binding var imageState: ImageState
    @State private var id: Int = 0
    
    init(imageState: Binding<ImageState>) {
        print("ImageView init")
        _imageState = imageState
    }
    
    var body: some View {
        
        print("ImageView render")
        
        return ZStack {
            Rectangle()
                .fill(imageState.isFailure ? .black : .white)
            
            switch imageState {
            case .SUCCESS(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                
            case .FAILURE(let msg):
                Text(msg)
                    .font(.system(size: TITLE_FONT_SIZE, weight: .bold))
                    .foregroundStyle(.white)
                
            case .LOADING:
                SpinnerView()
                    .id(id)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            print("ImageView Appeard")
            if case .LOADING = imageState { id += 1 }
        }
        .onDisappear {
            print("ImageView Disappeard")
        }
        
        
    }
}

#Preview {
    ImageView(imageState: .constant(.LOADING))
}
