//
//  DetailView.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import SwiftUI

struct DetailView: View {
    
    @Environment(ListVM.self) var listVM
    @Environment(\.dismiss) var dismiss
    
    @State private var vm: DetailVM
    
    init(vm: DetailVM) {
        print("DetailView \(vm.postId) init")
        _vm = State(wrappedValue: vm)
    }
    
    var body: some View {
        
        print("DetailView \(vm.postId) render")
        
        return List {
            if let hasPost = vm.post {
                Section(header:
                            Text("Image")
                                .font(.headline)
                                .padding(.bottom, 4)
                ) {
                    ImageView(imageState: $vm.imageState)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                        .onReadSize {
                            let width = Int($0.width)
                            if vm.imageWidth != width { vm.imageWidth = width }
                        }
                }
                
                Section(header:
                            Text("Post")
                                .font(.headline)
                                .padding(.bottom, 4)
                ) {
                    VStack(alignment: .leading, spacing: 16) {
                        CustomTextView(title: "id", text: "\(hasPost.id)")
                        CustomTextView(title: "title", text: "\(hasPost.title)")
                        CustomTextView(title: "body", text: "\(hasPost.body)")
                        CustomTextView(title: "userId", text: "\(hasPost.userId)")
                    }
                }
                
                if !vm.comments.isEmpty {
                    Section(header:
                                HStack {
                                        Text("Comments")
                                            .font(.headline)
                        
                                        Spacer()
                                        
                                        if vm.totalComments.count > 3 {
                                            Button {
                                                vm.didTapCommentsMoreBtn()
                                            } label: {
                                                Image(systemName: "chevron.\(vm.comments.count == 3 ? "down" : "up")")
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                }
                                .padding(.bottom, 4)
                    ) {
                        ForEach(vm.comments, id: \.id) { comment in
                            CommentView(comment: comment)
                        }
                    }
                }
            }
        }
        .navigationTitle("Detail")
        .task {
            await vm.fetchPostDetail()
        }
        .task(id: vm.imageWidth) {
            await vm.fetchImage()
        }
        .onAppear {
            print("DetailView \(vm.postId) Appeared")
        }
        .onDisappear {
            print("DetailView \(vm.postId) Disappeared")
        }
        .onChange(of: vm.isLoading) { _, newValue in
            listVM.isLoading = newValue
        }
        .onChange(of: vm.errorMsg) { _, newValue in
            listVM.errorMsg = newValue
        }
        .onChange(of: listVM.errorMsg) { oldValue, newValue in
            guard oldValue != nil, newValue == nil else { return }
            dismiss()
        }
        
        
    }
}

#Preview {
    NavigationStack {
        DetailView(vm: DetailVM(postId: 1, getPostDetailService: GetPostDetailService(postRepository: DefaultPostRepository(), imageRepository: DefaultImageRepository())))
            .environment(ListVM(getPostsService: GetPostsService(repository: DefaultPostRepository())))
    }
}
