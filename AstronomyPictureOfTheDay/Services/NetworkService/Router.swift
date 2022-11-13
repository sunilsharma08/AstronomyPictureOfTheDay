//
//  Router.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 10/11/22.
//

import Foundation
//import Reachability

typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter: AnyObject {
    func request(_ route: NetworkRequest, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router: NetworkRouter {
    
    private var task: URLSessionTask?
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request(_ route: NetworkRequest, completion: @escaping NetworkRouterCompletion) {
        if Reachability.isConnectedToNetwork() == false {
            completion(nil, nil, NetworkError.noInternet)
            return
        }
        
        do {
            let request = try RequestBuilder().buildRequest(from: route)
            
            task = session.dataTask(with: request, completionHandler: {[weak self] data, response, error in
                guard let self = self else { return }
                
                let httpStatus = self.handleHTTP(response: response)
                
                switch httpStatus {
                case .success:
                    completion(data, response, error)
                case .authError:
                    completion(data, response, NetworkError.authenticationError)
                default:
                    completion(data, response, NetworkError.unknown("Something went wrong!".localized))
                }
            })
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    /**
     Checks for different http status code and return HTTPStatus enum accordingly
     */
    private func handleHTTP(response: URLResponse?) -> HTTPStatus {
        guard let httpResponse = response as? HTTPURLResponse
        else { return .clientError }
        
        switch httpResponse.statusCode {
        case 200...299:
            return .success
        case 401, 403:
            return .authError
        case 400:
            return .clientError
        case 500...599:
            return .serverError
        default:
            return .clientError
        }
    }
    
}
