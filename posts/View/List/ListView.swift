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
            VStack(spacing: 0) {
                List {
                    ForEach(vm.posts, id: \.hashValue) { post in
                        ListRowView(post: post)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .onTapGesture { vm.didTapPostRow(post: post) }
                    }
                }
            }
            .navigationTitle("Posts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    CustomButton(title: "Create", horizontalPadding: 16) {
                        vm.didTapCreateBtn()
                    }
                }
            }
            .navigationDestination(for: ViewType.self) { viewType in
                if viewType == .DETAIL {
                    let detailVM = vm.getDetailVM()
                    DetailView(vm: detailVM)
                        .environmentObject(vm)
                    
                } else {
                    let createVM = vm.getCreateVM()
                    CreateView(vm: createVM)
                        .environmentObject(vm)
                }
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
