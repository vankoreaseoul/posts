//
//  SpinnerView.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import SwiftUI

struct SpinnerView: View {
    
    var body: some View {
        
        Rectangle()
            .fill(.black.opacity(0.7))
            .ignoresSafeArea()
            .overlay {
                VStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(1.5)
                        .padding()
                    
                    Text("Loading...")
                        .foregroundColor(.white)
                }
            }
        
        
    }
}

#Preview {
    SpinnerView()
}
