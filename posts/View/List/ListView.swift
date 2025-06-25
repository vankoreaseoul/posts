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
        
        return NavigationStack(path: $vm.navigationPath) {
            List(vm.posts, id: \.id) { post in
                NavigationLink(value: post.id) { ListRowView(post: post) }
            }
            .navigationTitle("Posts")
            .toolbar {
                ToolbarItem {
                    CustomButton(title: "Create", horizontalPadding: 16) {
                         vm.didTapCreateBtn()
                    }
                }
            }
            .navigationDestination(for: Post.ID.self) { id in
                if id != .zero {
                    DetailView(vm: DetailVM(postId: id, getPostDetailService: GetPostDetailService(postRepository: DefaultPostRepository(), imageRepository: DefaultImageRepository())))
                        .environment(vm)
                    
                } else {
                    CreateView(vm: CreateVM(createPostService: CreatePostService(repository: DefaultPostRepository())))
                        .environment(vm)
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
