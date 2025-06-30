//
//  ListRowLoadingView.swift
//  posts
//
//  Created by Heawon Seo on 6/30/25.
//

import SwiftUI

struct ListRowLoadingView: View {
    
    private let count: Int
    private let hasBtn: Bool
    
    init(count: Int, hasBtn: Bool = true) {
        print("ListRowLoadingView init")
        self.count = count
        self.hasBtn = hasBtn
    }
    
    var body: some View {
        print("ListRowLoadingView render")
        
        return HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(0..<count, id: \.self) { _ in
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(height: 12)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .shimmer()
                }
            }
            
            if hasBtn {
                Spacer()
                
                Image(systemName: "chevron.right")
                    .hidden()
            }
        }
        .onAppear {
            print("ListRowLoadingView Appeared")
        }
        .onDisappear {
            print("ListRowLoadingView Disappeared")
        }
    }
}

#Preview {
    ListRowLoadingView(count: 3)
}
