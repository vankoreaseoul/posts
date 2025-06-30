//
//  ImageView.swift
//  posts
//
//  Created by Heawon Seo on 5/30/25.
//

import SwiftUI

struct ImageView: View {
    
    @Binding var phase: ViewPhase<UIImage>
    
    init(phase: Binding<ViewPhase<UIImage>>) {
        print("ImageView init")
        _phase = phase
    }
    
    var body: some View {
        
        print("ImageView render")
        
        return VStack(spacing: 0) {
            switch phase {
            case .IDLE, .LOADING:
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .shimmer()
                
            case .LOADED(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                
            case .FAILED(let msg):
                Rectangle()
                    .fill(.black)
                    .overlay {
                        Text(msg)
                            .font(.system(size: TITLE_FONT_SIZE, weight: .bold))
                            .foregroundStyle(.white)
                    }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            print("ImageView Appeard")
        }
        .onDisappear {
            print("ImageView Disappeard")
        }
        
        
    }
}

#Preview {
    ImageView(phase: .constant(.FAILED("test")))
}
