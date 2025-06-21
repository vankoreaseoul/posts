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
        
        print("CommentView \(comment.id) render")
        
        return VStack(alignment: .leading, spacing: 16) {
            CustomTextView(title: "id", text: "\(comment.id)")
            CustomTextView(title: "name", text: comment.name)
            CustomTextView(title: "email", text: comment.email)
            CustomTextView(title: "body", text: comment.body)
        }
        .onAppear {
            print("CommentView \(comment.id) Appeared")
        }
        .onDisappear {
            print("CommentView \(comment.id) Disappeared")
        }
        
        
    }
}

#Preview {
    CommentView(comment: Comment(id: 1, name: "name", email: "email", body: "body", postId: 1))
}
