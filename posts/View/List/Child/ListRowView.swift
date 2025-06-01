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
        self.post = post
        
        print("ListRowView \(post.id) init")
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            CustomTextView(title: "id", text: post.id.description)
            CustomTextView(title: "title", text: post.title)
            CustomTextView(title: "userId", text: post.userId.description)
        }
        
        .onAppear {
            print("ListRowView \(post.id) Appeared")
        }
        
        
    }
}

#Preview {
    ListRowView(post: Post(id: 0, title: "title", body: "body", userId: 0))
}
