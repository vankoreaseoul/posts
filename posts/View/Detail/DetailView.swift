//
//  DetailView.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import SwiftUI

struct DetailView: View {
    
    @State private var vm: DetailVM
    
    init(vm: DetailVM) {
        print("DetailView \(vm.postId) init")
        _vm = State(wrappedValue: vm)
    }
    
    var body: some View {
        
        print("DetailView \(vm.postId) render")
        
        return VStack(spacing: 0) {
            switch vm.phase {
            case .IDLE, .LOADING:
                List {
                    Section(header:
                                Text("Image")
                                    .font(.headline)
                                    .padding(.bottom, 4)
                    ) {
                        ImageView(phase: $vm.imagePhase)
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
                            ListRowLoadingView(count: 4, hasBtn: false)
                        }
                    }
                    
                    Section(header:
                                Text("Comments")
                                    .font(.headline)
                                    .padding(.bottom, 4)
                    ) {
                        ForEach(0..<5) { _ in
                            ListRowLoadingView(count: 4, hasBtn: false)
                        }
                    }
                }
            
            case .LOADED(let post):
                List {
                    Section(header:
                                Text("Image")
                                    .font(.headline)
                                    .padding(.bottom, 4)
                    ) {
                        ImageView(phase: $vm.imagePhase)
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
                            CustomTextView(title: "id", text: "\(post.id)")
                            CustomTextView(title: "title", text: "\(post.title)")
                            CustomTextView(title: "body", text: "\(post.body)")
                            CustomTextView(title: "userId", text: "\(post.userId)")
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
                
            case .FAILED(let msg):
                Text(msg)
                    .font(.system(size: TITLE_FONT_SIZE))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }
        }
        .navigationTitle("Detail")
        .task {
            await vm.fetchPostDetail()
        }
        .onAppear {
            print("DetailView \(vm.postId) Appeared")
        }
        .onDisappear {
            print("DetailView \(vm.postId) Disappeared")
        }
        
        
    }
}

#Preview {
    NavigationStack {
        DetailView(vm: DetailVM(postId: 1, getPostDetailService: GetPostDetailService(postRepository: DefaultPostRepository(), imageRepository: DefaultImageRepository())))
    }
}
