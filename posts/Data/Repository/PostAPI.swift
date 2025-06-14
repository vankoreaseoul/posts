//
//  PostAPI.swift
//  posts
//
//  Created by Heawon Seo on 5/28/25.
//

import Moya
import Foundation

enum PostAPI {
    case getPosts
    case getComments(postId: Int)
    case createPost(post: Post)
}

extension PostAPI: TargetType {
    var baseURL: URL {
        return URL(string: POST_URL)!
    }
       
    var path: String {
        switch self {
        case .getPosts, .createPost:
            return "/posts"
        case .getComments(let postId):
            return "/posts/\(postId)/comments"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPosts, .getComments:
            return .get
        case .createPost:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getPosts, .getComments:
            return .requestPlain
        case .createPost(let post):
            return .requestJSONEncodable(post.switchToCreatePostRequestDTO())
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
