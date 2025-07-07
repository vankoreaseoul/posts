//
//  ListView.swift
//  posts
//
//  Created by Heawon Seo on 5/28/25.
//

import SwiftUI
import Swinject

struct ListView: View {
        
    @State private var vm: ListVM
     
    init(vm: ListVM) {
        print("ListView init")
        _vm = State(wrappedValue: vm)
    }
    
    var body: some View {
        
        print("ListView render")
        
        return VStack(spacing: 0) {
            switch vm.phase {
            case .IDLE, .LOADING:
                List { ForEach(0..<12) { _ in ListRowLoadingView(count: 3) } }
                
            case .LOADED(let posts):
                if posts.isEmpty {
                    NoticeView(text: "No posts", btnTitle: "Refresh", isBtnTapped: $vm.isRefreshBtnTapped)
                    
                } else {
                    List(posts, id: \.id) { post in
                        Button { vm.didTapListRow(postId: post.id) } label: { ListRowView(post: post) }.tint(.black)
                    }
                    .refreshable { await vm.fetchPosts() }
                }
                
            case .FAILED(let msg):
                NoticeView(text: msg, btnTitle: "Refresh", isBtnTapped: $vm.isRefreshBtnTapped)
            }
        }
        .navigationTitle("Posts")
        .toolbar {
            ToolbarItem {
                CustomButton(title: "Create", horizontalPadding: 16) { vm.didTapCreateBtn() }
            }
        }
        .padding(.bottom, 1)
        .task { if !vm.isPostsFetched { await vm.fetchPosts() } }
        .onAppear {
            print("ListView Appeared")
        }
        .onDisappear {
            print("ListView Disappeared")
        }
        
        
    }
}

#Preview {
    ListView(vm: ListVM(getPostsService: GetPostsService(repository:DefaultPostRepository()), coordinator: DefaultCoordinator(injector: DefaultInjector(container: Container()), initialScene: .LIST)))
}
