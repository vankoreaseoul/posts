//
//  CreateView.swift
//  posts
//
//  Created by Heawon Seo on 5/31/25.
//

import SwiftUI
import Swinject

struct CreateView: View {
    
    @State private var vm: CreateVM
    
    init(vm: CreateVM) {
        print("CreateView init")
        _vm = State(wrappedValue: vm)
    }
    
    var body: some View {
        
        print("CreateView render")
        
        return ScrollView {
            VStack(spacing: 32) {
                
                // Title
                VStack(alignment: .leading, spacing: 16) {
                    Text("Title")
                        .font(.system(size: TITLE_FONT_SIZE, weight: .bold))
                    
                    TextField("Enter title", text: $vm.title)
                        .textFieldStyle(.roundedBorder)
                }
                
                // Body
                VStack(alignment: .leading, spacing: 16) {
                    Text("Body")
                        .font(.system(size: TITLE_FONT_SIZE, weight: .bold))
                    
                    TextEditor(text: $vm.body)
                        .padding(.horizontal, 4)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(3/2, contentMode: .fit)
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
                }
                
                CustomButton(title: "Post", fontSize: 18, verticalPadding: 16, bgColor: vm.title.isEmpty || vm.body.isEmpty ? .gray : .blue, disabled: vm.title.isEmpty || vm.body.isEmpty) {
                    vm.didTapPostBtn()
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 1)
//        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationTitle("Create")
        .contentShape(Rectangle())
        .onTapGesture { vm.didTapBackground() }
        .onAppear {
            print("CreateView Appeared")
        }
        .onDisappear {
            print("CreateView Disappeared")
        }
        
    }
}

#Preview {
    NavigationStack {
        CreateView(vm: CreateVM(createPostService: CreatePostService(repository: DefaultPostRepository()), coordinator: DefaultCoordinator(injector: DefaultInjector(container: Container()), initialScene: .LIST)))
    }
}
