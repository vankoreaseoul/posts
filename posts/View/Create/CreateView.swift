//
//  CreateView.swift
//  posts
//
//  Created by Heawon Seo on 5/31/25.
//

import SwiftUI

struct CreateView: View {
    
//    @EnvironmentObject private var listVM: ListVM
    @ObservedObject private var vm: CreateVM
    
    init(vm: CreateVM) {
        _vm = ObservedObject(wrappedValue: vm)
        
        print("CreateView init")
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            Text("Title")
                .font(.system(size: TITLE_FONT_SIZE, weight: .bold))
            
            TextField("Enter title", text: $vm.title)
                .textFieldStyle(.roundedBorder)
            
            Text("Body")
                .font(.system(size: TITLE_FONT_SIZE, weight: .bold))
            
            TextEditor(text: $vm.body)
                .padding(.horizontal, 4)
                .frame(height: 200)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2))
                        .overlay(alignment: .topLeading) {
                            if vm.body.isEmpty {
                                Text("Enter body")
                                    .font(.system(size: 17))
                                    .foregroundStyle(.tertiary)
                                    .padding([.leading, .top], 8)
                            }
                        }
                }
            
            Spacer()
            
            CustomButton(title: "Post", fontSize: 18, verticalPadding: 16, bgColor: vm.title.isEmpty || vm.body.isEmpty ? .gray : .blue, disabled: vm.title.isEmpty || vm.body.isEmpty) {
                UIApplication.shared.hideKeyboard()
                vm.didTapPostBtn()
            }
        }
        .applyPadding()
        .navigationTitle("Create")
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        
        
        .onAppear {
            print("CreateView Appeared")
        }
        .onDisappear {
            print("CreateView Disappeared")
//            listVM.createVM = nil
        }
//        .onChange(of: vm.newPost) { oldValue, newValue in
//            guard oldValue == nil, let hasNewValue = newValue else { return }
            
//            listVM.posts.insert(hasNewValue, at: 0)
//            listVM.path.removeLast()
//        }
        .onChange(of: vm.errorMsg) { oldValue, newValue in
//            listVM.errorMsg = newValue
        }
        
        
    }
}

//#Preview {
//    CreateView(vm: CreateVM(createPostService: CreatePostServiceImpl(repository: PostRepositoryImpl())))
//}
