//
//  RequestBuilderTests.swift
//  AstronomyPictureOfTheDayTests
//
//  Created by Sunil Sharma on 13/11/22.
//

import XCTest
@testable import AstronomyPictureOfTheDay

enum TestAPI {
    case getTestAPI
    case postTestAPI
}

extension TestAPI: NetworkRequest {
    var baseUrl: String {
        return "https://www.example.com"
    }
    
    var path: String {
        switch self {
        case .getTestAPI:
            return "/starlist"
        case .postTestAPI:
            return "/update/starlist"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getTestAPI:
            return .get
        case .postTestAPI:
            return .post
        }
    }
}

class RequestBuilderTests: XCTestCase {

    let requestBuilder = RequestBuilder()
    
    /**
     Test request HTTP url
     */
    func testRequestUrl() {
        do {
            let request = try requestBuilder.buildRequest(from: TestAPI.getTestAPI)
            XCTAssertTrue(request.url!.absoluteString == "https://www.example.com/starlist", "Incorrect url string generated.")
        } catch  {
            XCTFail("Unexpected request builder throw exception")
        }
        
        do {
            let request = try requestBuilder.buildRequest(from: TestAPI.postTestAPI)
            XCTAssertTrue(request.url!.absoluteString == "https://www.example.com/update/starlist", "Incorrect url string generated.")
        } catch  {
            XCTFail("Unexpected request builder throw exception")
        }
    }
    
    /**
     Test request HTTP METHOD type
     */
    func testRequestMethod() {
        do {
            let request = try requestBuilder.buildRequest(from: TestAPI.getTestAPI)
            XCTAssertTrue(request.httpMethod == "GET", "Incorrect request method type. Expected GET but found \(String(describing: request.httpMethod))")
        } catch  {
            XCTFail("Unexpected request builder throw exception")
        }
        
        do {
            let request = try requestBuilder.buildRequest(from: TestAPI.postTestAPI)
            XCTAssertTrue(request.httpMethod == "POST", "Incorrect request method type. Expected POST but found \(String(describing: request.httpMethod))")
        } catch  {
            XCTFail("Unexpected request builder throw exception")
        }
    }

}
