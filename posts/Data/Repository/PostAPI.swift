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
    case getPost(id: Int)
    case getComments(postId: Int)
    case createPost(post: Post)
}

extension PostAPI: TargetType {
    var baseURL: URL { URL(string: POST_URL)! }
       
    var path: String {
        switch self {
        case .getPosts, .createPost:
            return "/posts"
        case .getPost(let id):
            return "/posts/\(id)"
        case .getComments(let postId):
            return "/posts/\(postId)/comments"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPosts, .getPost, .getComments:
            return .get
        case .createPost:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getPosts, .getPost, .getComments:
            return .requestPlain
        case .createPost(let post):
            return .requestJSONEncodable(CreatPostRequestDTO(from: post))
        }
    }
    
    var headers: [String : String]? { ["Content-Type": "application/json"] }
}

extension MoyaProvider {
    func asyncRequest<T: Decodable>(_ type: T.Type, _ target: Target) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            self.request(target) {
                let result = self.parsing(T.self, result: $0)
                switch result {
                case .success(let entity):
                    continuation.resume(returning: entity)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func parsing<T: Decodable>(_ type: T.Type, result: Result<Response, MoyaError>) -> Result<T, NetworkError> {
        switch result {
        case .success(let response):
            guard let entity = try? JSONDecoder().decode(type, from: response.data) else { return .failure(switchToError(.jsonMapping(response))) }
            return .success(entity)
            
        case .failure(let moyaError):
            return .failure(switchToError(moyaError))
        }
    }
    
    private func switchToError(_ moyaError: MoyaError) -> NetworkError {
        switch moyaError {
        case .statusCode(let response):
            return .serverError(statusCode: response.statusCode)
        case .underlying(let nsError, _):
            return .networkFailure(msg: nsError.localizedDescription)
        case .requestMapping, .parameterEncoding, .jsonMapping:
            return .invalidRequest
        default:
            return .unknown
        }
    }
    
    enum NetworkError: Error {
        case serverError(statusCode: Int)   // 서버 상태 코드 오류
        case networkFailure(msg: String)    // 네트워크 실패 (인터넷 연결 문제 등)
        case invalidRequest                 // 잘못된 요청
        case unknown                        // 알 수 없는 오류
    }
    
}
