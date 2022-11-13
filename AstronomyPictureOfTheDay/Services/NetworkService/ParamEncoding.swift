//
//  ParamEncoding.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 10/11/22.
//

import Foundation

protocol ParamEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: HTTPParam) throws
}

struct URLParamEncoder: ParamEncoder {
    
    func encode(urlRequest: inout URLRequest, with parameters: HTTPParam) throws {
        
        guard let url = urlRequest.url else { throw NetworkError.urlMissing }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
           !parameters.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
    }
}

struct JSONParamEncoder: ParamEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: HTTPParam) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
        } catch {
            throw NetworkError.paramEncodingFailed
        }
    }
}
