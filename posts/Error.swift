//
//  Error.swift
//  posts
//
//  Created by Heawon Seo on 7/7/25.
//

import Foundation
import Moya
import Kingfisher

enum PostError: Error {
    case CANCEL_REQUEST
    case TIME_OUT
    case MOYA_ERROR(MoyaError)
    case KINGFISHER_ERROR(KingfisherError)
}

extension MoyaError {
    func switchToPostError() -> PostError {
        if case .underlying(let nsError as NSError, _) = self {
            if nsError.code == NSURLErrorCancelled {
                return .CANCEL_REQUEST
            } else if nsError.code == NSURLErrorTimedOut {
                return .TIME_OUT
            }
        }
        return .MOYA_ERROR(self)
    }
}

extension KingfisherError {
    func switchToPostError() -> PostError {
        if case .requestError(.taskCancelled) = self {
            return .CANCEL_REQUEST
        } else if case .responseError(.URLSessionError) = self {
            return .TIME_OUT
        }
        return .KINGFISHER_ERROR(self)
    }
}
