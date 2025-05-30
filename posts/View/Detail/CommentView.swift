//
//  CommentView.swift
//  posts
//
//  Created by Heawon Seo on 5/30/25.
//

import SwiftUI

struct CommentView: View {
    
    let comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
        
        print("CommentView \(comment.id) init")
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Text("id:")
                    .bold()
                
                Text(comment.id.description)
            }
            
            HStack(alignment: .top, spacing: 4) {
                Text("name:")
                    .bold()
                
                Text(comment.name)
            }
            
            HStack(alignment: .top, spacing: 4) {
                Text("email:")
                    .bold()
                
                Text(comment.email)
            }
            
            HStack(alignment: .top, spacing: 4) {
                Text("body:")
                    .bold()
                
                Text(comment.body)
            }
        }
        .font(.system(size: 14))
        
        .onAppear {
            print("CommentView \(comment.id) Appeared")
        }
        
        
    }
}

#Preview {
    CommentView(comment: Comment(id: 1, name: "name", email: "email", body: "body", postId: 1))
}
