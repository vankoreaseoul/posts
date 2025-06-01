//
//  postsApp.swift
//  posts
//
//  Created by Heawon Seo on 5/28/25.
//

import SwiftUI

@main
struct postsApp: App {
    
    private let listVM = ListVM(getPostsService: GetPostsServiceImpl(repository: DIContainer.shared.getPostRepository()))
    
    var body: some Scene {
        WindowGroup {
            ListView(vm: listVM)
        }
    }
    
}
