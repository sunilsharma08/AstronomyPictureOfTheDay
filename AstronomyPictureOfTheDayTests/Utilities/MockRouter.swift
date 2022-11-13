//
//  MockRouter.swift
//  AstronomyPictureOfTheDayTests
//
//  Created by Sunil Sharma on 13/11/22.
//

import XCTest
@testable import AstronomyPictureOfTheDay

class MockRouter: NetworkRouter {
    
    private var task: URLSessionTask?
    let session: URLSession
    var mockData: (data: Data?, response: URLResponse?, error: Error?)?
    
    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)) {
        self.session = session
    }
    
    func request(_ route: NetworkRequest, completion: @escaping NetworkRouterCompletion) {
        completion(mockData?.data, mockData?.response, mockData?.error)
    }
    
    func cancel() {
        task?.cancel()
    }
}
