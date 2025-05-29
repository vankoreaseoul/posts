//
//  Extension.swift
//  posts
//
//  Created by Heawon Seo on 5/29/25.
//

import Foundation
import Moya

extension Error {
    func getMsg() -> String {
        guard let moyaError = self as? MoyaError else { return "An unknown error occurred." }
        
        switch moyaError {
        case .imageMapping(let response):
            return "Failed to process image data. (Status code: \(response.statusCode))"
        case .jsonMapping(let response):
            return "Failed to parse JSON data. (Status code: \(response.statusCode))"
        case .stringMapping(let response):
            return "Failed to convert response to string. (Status code: \(response.statusCode))"
        case .objectMapping(let error, let response):
            return "Failed to decode response. (\(error.localizedDescription), Status code: \(response.statusCode))"
        case .encodableMapping(let error):
            return "Failed to encode request data. (\(error.localizedDescription))"
        case .statusCode(let response):
            return "Received an error response from the server. (Status code: \(response.statusCode))"
        case .underlying(let error, _):
            return "A network error occurred. (\(error.localizedDescription))"
        case .requestMapping(let string):
            return "Invalid request configuration. (\(string))"
        case .parameterEncoding(let error):
            return "Failed to encode parameters. (\(error.localizedDescription))"
        }
    }
}
