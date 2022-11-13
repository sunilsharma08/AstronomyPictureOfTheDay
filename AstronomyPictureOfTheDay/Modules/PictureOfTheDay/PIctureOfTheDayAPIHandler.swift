//
//  PIctureOfTheDayAPIHandler.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 11/11/22.
//

import Foundation

enum PictureOfTheDayAPI {
    case pictureOfTheDay
    case search(date: String)
}

extension PictureOfTheDayAPI: NetworkRequest {
    
    var baseUrl: String {
        switch APIEnvironment.current {
        case .debug: return "https://api.nasa.gov"
        case .release: return "https://api.nasa.gov"
        }
    }
    
    var path: String {
        return "/planetary/apod"
    }
    
    var urlParams: HTTPParam? {
        var urlParam: [String: Any] = [:]
        urlParam["api_key"] = "UaIEMcOtfaGnWebgBCulqFeRJ4y5yR7KRPCChP2Y"
        urlParam["thumbs"] = true
        
        switch self {
        case .search(date: let dateStr):
            urlParam["date"] = dateStr
        default:
            break
        }
        
        return urlParam
    }
}

struct PIctureOfTheDayAPIHandler {
    let router: NetworkRouter
    
    init(router: NetworkRouter = Router()) {
        self.router = router
    }
    
    func getPictureOfTheDay(completion: @escaping (Result<[MediaInfo], NetworkError>) -> Void) {
        router.request(PictureOfTheDayAPI.pictureOfTheDay) { (data, response, error) in
            
            if let networkError = error as? NetworkError {
                completion(.failure(networkError))
            } else if let payloadData = data {
                do {
                    let mediaInfo = try JSONDecoder().decode(MediaInfo.self, from: payloadData)
                    completion(.success([mediaInfo]))
                } catch {
                    completion(.failure(.unknown(error.localizedDescription)))
                }
            }
        }
    }
    
    func search(date: Date, completion: @escaping (Result<[MediaInfo], NetworkError>) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: date)
        router.request(PictureOfTheDayAPI.search(date: dateStr)) { data, response, error in
            if let networkError = error {
                completion(.failure(.unknown(networkError.localizedDescription)))
            } else if let payloadData = data {
                do {
                    let mediaInfo = try JSONDecoder().decode(MediaInfo.self, from: payloadData)
                    completion(.success([mediaInfo]))
                } catch {
                    completion(.failure(.unknown(error.localizedDescription)))
                }
            }
        }
    }
}
