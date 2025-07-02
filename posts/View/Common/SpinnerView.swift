//
//  SpinnerView.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import SwiftUI

struct SpinnerView: View {
    
    init() {
        print("SpinnerView init")
    }
    
    var body: some View {
        
        print("SpinnerView render")
        
        return Rectangle()
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
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                }
            }
            .presentationBackground(.clear)
            .onAppear {
                print("SpinnerView Appeared")
            }
            .onDisappear {
                print("SpinnerView Disappeared")
            }
        
        
    }
}

#Preview {
    SpinnerView()
}
