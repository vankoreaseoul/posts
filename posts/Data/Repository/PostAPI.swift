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
}

extension PostAPI: TargetType {
    var baseURL: URL {
        return URL(string: USED_URL)!
    }
       
    var path: String {
        switch self {
        case .getPosts:
            return "/posts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPosts:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPosts:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
