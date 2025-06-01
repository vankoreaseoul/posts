//
//  DetailView.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import SwiftUI

struct DetailView: View {
    
    @EnvironmentObject private var listVM: ListVM
    @ObservedObject private var vm: DetailVM
    
    init(vm: DetailVM) {
        _vm = ObservedObject(wrappedValue: vm)
        
        print("DetailView init")
    }
    
    var body: some View {
        
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16) {
                
                ImageView(postId: vm.post.id)
                
                // Post
                VStack(alignment: .leading, spacing: 8) {
                    CustomTextView(title: "id", text: vm.post.id.description)
                    CustomTextView(title: "title", text: vm.post.title)
                    CustomTextView(title: "body", text: vm.post.body)
                    CustomTextView(title: "userId", text: vm.post.userId.description)
                }
                
                if !vm.comments.isEmpty {
                    Divider()
                        .frame(height: 2)
                        .background(Color.gray)
                        .overlay {
                            Text("Comments")
                                .font(.system(size: TEXT_FONT_SIZE, weight: .bold))
                                .padding(.horizontal, 4)
                                .background(.white)
                        }
                }
                    
                // Comments
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(Array(vm.comments.enumerated()), id: \.element.id) { index, comment in
                        CommentView(comment: comment)
                        if index != 2 { Divider() }
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .applyPadding()
        }
        
        .onAppear {
            vm.loadComments()
            print("DetailView Appeared")
        }
        .onDisappear {
            listVM.detailVM = nil
            print("DetailView Disappeared")
        }
        .onChange(of: vm.errorMsg) { oldValue, newValue in
            listVM.errorMsg = newValue
        }
        
        
    }
}

#Preview {
    DetailView(vm: DetailVM(getFirstThreeCommentsService: GetFirstThreeCommentsServiceImpl(repository: PostRepositoryImpl()), post: Post(id: 1, title: "test", body: "test", userId: 1)))
}
