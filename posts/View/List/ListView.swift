//
//  ListView.swift
//  posts
//
//  Created by Heawon Seo on 5/28/25.
//

import SwiftUI

struct ListView: View {
        
    @State private var vm: ListVM
     
    init(vm: ListVM) {
        print("ListView init")
        _vm = State(wrappedValue: vm)
    }
    
    var body: some View {
        
        print("ListView render")
        
        return NavigationStack(path: $vm.navigationPath) {
            VStack(spacing: 0) {
                switch vm.phase {
                case .IDLE, .LOADING:
                    List { ForEach(0..<12) { _ in ListRowLoadingView(count: 3) } }
                    
                case .LOADED(let posts):
                    if posts.isEmpty {
                        VStack(spacing: 12) {
                            Text("No posts")
                                .font(.system(size: TITLE_FONT_SIZE))
                            
                            CustomButton(title: "Refresh") {}
                                .refreshable { await vm.fetchPosts() }
                        }
                        .padding(.horizontal, 16)
                        
                    } else {
                        List {
                            ForEach(posts, id: \.id) { post in
                                NavigationLink(value: post.id) { ListRowView(post: post) }
                            }
                        }
                        .refreshable { await vm.fetchPosts() }
                    }
                    
                case .FAILED(let msg):
                    VStack(spacing: 12) {
                        Text(msg)
                            .font(.system(size: TITLE_FONT_SIZE))
                            .multilineTextAlignment(.center)
                          
                        CustomButton(title: "Refresh") {}
                            .refreshable { await vm.fetchPosts() }
                    }
                    .padding(.horizontal, 16)
                }
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
                    
                } else {
                    CreateView(vm: CreateVM(createPostService: CreatePostService(repository: DefaultPostRepository())))
                        .environment(vm)
                }
            }
        }
        .padding(.bottom, 1)
        .overlay { if vm.isSpinnerViewPresented { SpinnerView() } }
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
    ListView(vm:
                ListVM(getPostsService:
                        GetPostsService(repository:
                                            DefaultPostRepository()
                                       )
                      )
    )
}
