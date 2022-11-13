//
//  RequestBuilder.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 10/11/22.
//

import Foundation

class RequestBuilder {
    
    func buildRequest(from route: NetworkRequest) throws -> URLRequest {
        guard let baseURL = URL(string: route.baseUrl)
        else {
            throw NetworkError.urlMissing
        }
        
        var request = URLRequest(url: baseURL.appendingPathComponent(route.path),
                                 cachePolicy: route.cachePolicy,
                                 timeoutInterval: route.timeoutInterval)
        
        request.httpMethod = route.httpMethod.rawValue
        addHeaders(route: route, request: &request)
        do {
            try configureParams(route: route, request: &request)
        } catch {
            throw error
        }
        
        return request
    }
    
    private func addHeaders(route: NetworkRequest, request: inout URLRequest) {
        guard let headers = route.headers else { return }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func configureParams(route: NetworkRequest, request: inout URLRequest) throws {
        
        if let urlParam = route.urlParams {
            do {
                try URLParamEncoder().encode(urlRequest: &request, with: urlParam)
            } catch {
                throw error
            }
        }
        
        if let bodyParam = route.bodyParams {
            do {
                try JSONParamEncoder().encode(urlRequest: &request, with: bodyParam)
            } catch {
                throw error
            }
        }
    }
}
