//
//  ListRowView.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import SwiftUI

struct ListRowView: View {
    
    let post: Post
    
    init(post: Post) {
        print("ListRowView \(post.id) init")
        self.post = post
    }
    
    var body: some View {
        print("ListRowView \(post.id) render")
        
        return HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                CustomTextView(title: "id", text: "\(post.id)")
                CustomTextView(title: "title", text: post.title)
                CustomTextView(title: "userId", text: "\(post.userId)")
            }
            
            Spacer(minLength: 4)
            
            Image(systemName: "chevron.right")
                .renderingMode(.template)
                .tint(.blue)
        }
        .onAppear {
            print("ListRowView \(post.id) Appeared")
        }
        .onDisappear {
            print("ListRowView \(post.id) Disappeared")
        }
        
        
    }
}

#Preview {
    ListRowView(post: Post(id: 0, title: "title", body: "body", userId: 0))
}
