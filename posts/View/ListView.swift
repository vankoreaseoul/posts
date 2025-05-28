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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            vm.loadPosts()
        }
        
    }
}

#Preview {
    ListView()
}
