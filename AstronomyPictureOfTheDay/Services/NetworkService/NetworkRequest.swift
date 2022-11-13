//
//  NetworkRequest.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 10/11/22.
//

import Foundation

enum HTTPStatus {
    case success
    case authError
    case serverError
    case clientError
}

enum NetworkError: LocalizedError {
    case noInternet
    case paramEncodingFailed
    case urlMissing
    case authenticationError
    case unknown(String)
    
    
    var errorDescription: String? {
        
        switch self {
        case .noInternet:
            return "No Internet Connection"
        case .paramEncodingFailed:
            return "Parameter encoding failed"
        case .urlMissing:
            return "URL is nil"
        case .authenticationError:
            return "Failed to authenticate"
        case .unknown(let errorMsg):
            return errorMsg
        }
    }
}

typealias HTTPParam = [String: Any]
typealias HTTPHeaders = [String: String]

//This defines the type of HTTP request
enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case head    = "HEAD"
}

protocol NetworkRequest {
    var baseUrl: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var urlParams: HTTPParam? { get }
    var bodyParams: HTTPParam? { get }
    var timeoutInterval: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
}

extension NetworkRequest {
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var urlParams: HTTPParam? {
        return nil
    }
    
    var bodyParams: HTTPParam? {
        return nil
    }
    
    var timeoutInterval: TimeInterval {
        return 60
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }
}
