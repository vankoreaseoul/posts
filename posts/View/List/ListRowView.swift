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
            HStack(spacing: 4) {
                Text("id:")
                    .bold()
                
                Text(post.id.description)
            }
            
            HStack(alignment: .top, spacing: 4) {
                Text("title:")
                    .bold()
                
                Text(post.title)
            }
            
            HStack(spacing: 4) {
                Text("userId:")
                    .bold()
                
                Text(post.userId.description)
            }
        }
        .font(.system(size: 14))
        
        .onAppear {
            print("ListRowView \(post.id) Appeared")
        }
        
        
    }
}

#Preview {
    ListRowView(post: Post(id: 0, title: "title", body: "body", userId: 0))
}
