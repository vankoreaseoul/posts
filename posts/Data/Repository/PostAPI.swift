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
            self.request(target) { result in
                let parsedResult = self.parsing(T.self, result: result)
                switch parsedResult {
                case .success(let entity):
                    continuation.resume(returning: entity)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func asyncCancellableRequest<T: Decodable>(_ type: T.Type, _ target: Target) async throws -> T {
        
        let cancellableStorage = CancellableStorage()
        let continuationStorage = ContinuationStorage<T>()
        
        return try await withTaskCancellationHandler {
            
            try await withCheckedThrowingContinuation { continuation in
                _Concurrency.Task { await continuationStorage.store(continuation) }
                
                let cancellable = self.request(target) { result in
                    let parsedResult = self.parsing(T.self, result: result)
                    _Concurrency.Task { await continuationStorage.resume(parsedResult) }
                }
                
                _Concurrency.Task { await cancellableStorage.store(cancellable) }
            }
            
        } onCancel: {
            _Concurrency.Task.detached {
                await cancellableStorage.cancel()
                await continuationStorage.resume(.failure(.CANCEL_REQUEST))
            }
        }
    }
    
    private func parsing<T: Decodable>(_ type: T.Type, result: Result<Response, MoyaError>) -> Result<T, PostError> {
        switch result {
        case .success(let response):
            guard let entity = try? JSONDecoder().decode(type, from: response.data) else { return .failure(.MOYA_ERROR(.jsonMapping(response))) }
            return .success(entity)
            
        case .failure(let moyaError):
            return .failure(moyaError.switchToPostError())
        }
    }
    
    actor CancellableStorage {
        private var cancellable: Cancellable?

        func store(_ cancellable: Cancellable) { self.cancellable = cancellable }

        func cancel() { self.cancellable?.cancel() }
    }
}

actor ContinuationStorage<T> {
    private var continuation: CheckedContinuation<T, Error>?
    private var isResumed = false
    
    func store(_ continuation: CheckedContinuation<T, Error>) { self.continuation = continuation }

    func resume(_ result: Result<T, PostError>) {
        guard !isResumed else { return }
        isResumed = true
        
        switch result {
        case .success(let entity):
            continuation?.resume(returning: entity)
        case .failure(let error):
            continuation?.resume(throwing: error)
        }
    }
}
