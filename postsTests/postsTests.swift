//
//  postsTests.swift
//  postsTests
//
//  Created by Heawon Seo on 6/17/25.
//

import Testing
@testable import posts

struct postsTests {

    @Test
    func fetchPosts() async throws {
        let getPostsService = GetPostsService(repository: DefaultPostRepository())
        
        do {
            let posts = try await getPostsService.execute()
            print("post = \(posts)")
            
        } catch {
            print("msg = \(error)")
        }
    }
    
    @Test
    func fetchPost() async throws {
        let getPostDetailService = GetPostDetailService(repository: DefaultPostRepository())
        
        do {
            let post = try await getPostDetailService.execute(id: 1)
            print("post = \(post)")
            
        } catch {
            print("msg = \(error)")
        }
    }

}
