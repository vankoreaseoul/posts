//
//  ListView.swift
//  posts
//
//  Created by Heawon Seo on 5/28/25.
//

import SwiftUI

struct ListView: View {
    
    @ObservedObject private var vm: ListVM
    
    init(vm: ListVM) {
        _vm = ObservedObject(wrappedValue: vm)
        
        print("ListView init")
    }
    
    var body: some View {
        
        NavigationStack(path: $vm.path) {
            List {
                ForEach(vm.posts, id: \.id) { post in
                    ListRowView(post: post)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture { vm.didTapPostRow(post: post) }
                }
            }
            .navigationTitle("Posts")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Post.self) { post in
                let detailVM = vm.getDetailVM(post: post)
                DetailView(vm: detailVM, errorMsg: $vm.errorMsg)
            }
        }
        .padding(.vertical, 4)
        .overlay {
            if let hasErrorMsg = vm.errorMsg {
                if hasErrorMsg.isEmpty {
                    SpinnerView()
                } else {
                    AlertView(msg: $vm.errorMsg)
                }
            }
        }
        
        .onAppear {
            vm.loadPosts()
            print("ListView Appeared")
        }
        
        
    }
}

#Preview {
    ListView(vm: ListVM(getPostsService: GetPostsServiceImpl(repository: PostRepositoryImpl())))
}
