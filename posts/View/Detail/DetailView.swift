//
//  DetailView.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import SwiftUI

struct DetailView: View {
    
    @ObservedObject private var vm: DetailVM
    @Binding var errorMsg: String?
    
    init(vm: DetailVM, errorMsg: Binding<String?>) {
        _vm = ObservedObject(wrappedValue: vm)
        _errorMsg = errorMsg
        
        print("DetailView init")
    }
    
    var body: some View {
        
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16) {
                
                ImageView(postId: vm.post.id)
                
                // Post
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Text("id:")
                            .bold()
                        
                        Text(vm.post.id.description)
                    }
                    
                    HStack(alignment: .top, spacing: 4) {
                        Text("title:")
                            .bold()
                        
                        Text(vm.post.title)
                    }
                    
                    HStack(alignment: .top, spacing: 4) {
                        Text("body:")
                            .bold()
                        
                        Text(vm.post.body)
                    }
                    
                    HStack(spacing: 4) {
                        Text("userId:")
                            .bold()
                        
                        Text(vm.post.userId.description)
                    }
                }
                
                Divider()
                    .frame(height: 2)
                    .background(Color.gray)
                    .overlay {
                        Text("Comments")
                            .font(.system(size: 14, weight: .bold))
                            .padding(.horizontal, 4)
                            .background(.white)
                    }
                    
                // Comments
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(Array(vm.comments.enumerated()), id: \.element.id) { index, comment in
                        CommentView(comment: comment)
                        if index != 2 { Divider() }
                    }
                }
                
            }
            .padding(.horizontal, 16)
        }
        .font(.system(size: 14))
        
        .onAppear {
            vm.loadComments()
            print("DetailView Appeared")
        }
        .onChange(of: vm.errorMsg) { oldValue, newValue in
            errorMsg = newValue
        }
        
        
    }
}

#Preview {
    DetailView(vm: DetailVM(getFirstThreeCommentsService: GetFirstThreeCommentsServiceImpl(repository: PostRepositoryImpl()), post: Post(id: 1, title: "test", body: "test", userId: 1)), errorMsg: .constant("test"))
}
