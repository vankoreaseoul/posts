//
//  ListView.swift
//  posts
//
//  Created by Heawon Seo on 5/28/25.
//

import SwiftUI

struct ListView: View {
        
    @State private var vm = ListVM(getPostsService: GetPostsService(repository: DefaultPostRepository()))
     
    init() { print("ListView init") }
    
    var body: some View {
        
        print("ListView render")
        
        return NavigationStack {
            List(vm.posts, id: \.id) { post in
                NavigationLink {
                    DetailView(vm: DetailVM(postId: post.id, getPostDetailService: GetPostDetailService(repository: DefaultPostRepository())))
                        .environment(vm)
                    
                } label: {
                    ListRowView(post: post)
                }
            }
            .navigationTitle("Posts")
            .toolbar {
                ToolbarItem {
                    CustomButton(title: "Create", horizontalPadding: 16) {
                        // vm.didTapCreateBtn()
                    }
                }
            }
        }
        .padding(.bottom, 1)
        .overlay { if vm.isLoading { SpinnerView() } }
        .alert("Notice", isPresented: .constant(vm.errorMsg != nil)) {
            Button("OK") { vm.didTapAlertOkBtn() }
        } message: {
            Text(vm.errorMsg ?? "")
        }
        .task {
            await vm.fetchPosts()
        }
        .onAppear {
            print("ListView Appeared")
        }
        .onDisappear {
            print("ListView Disappeared")
        }
        
        
    }
}

#Preview {
    ListView()
}
