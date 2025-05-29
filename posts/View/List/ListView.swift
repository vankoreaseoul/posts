//
//  ListView.swift
//  posts
//
//  Created by Heawon Seo on 5/28/25.
//

import SwiftUI

struct ListView: View {
    
    @StateObject private var vm: ListVM
    
    init() {
        let vm = ListVM(getPostsService: GetPostsServiceImpl(repository: PostRepositoryImpl()))
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        
        NavigationStack(path: $vm.path) {
            List {
                ForEach(vm.posts, id: \.id) { post in
                    ListRowView(post: post)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture { vm.path.append(post.id) }
                }
            }
            .navigationTitle("Posts")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Int.self) { id in
                Text("\(id)")
            }
        }
        .padding(.vertical, 4)
        .overlay {
            if vm.topViewType == .SPINNER {
                SpinnerView()
            } else if vm.topViewType == .ALERT {
                AlertView(msg: vm.errorMsg, viewType: $vm.topViewType)
            }
        }
        
        
        .onAppear {
            vm.loadPosts()
        }
        
        
    }
}

#Preview {
    ListView()
}
