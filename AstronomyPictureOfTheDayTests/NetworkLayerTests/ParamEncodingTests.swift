//
//  ParamEncodingTests.swift
//  AstronomyPictureOfTheDayTests
//
//  Created by Sunil Sharma on 13/11/22.
//

import XCTest
@testable import AstronomyPictureOfTheDay

class ParamEncodingTests: XCTestCase {

    func testURLEncoding() {
        guard let url = URL(string: "https://www.example.com/") else {
            XCTAssertTrue(false, "Could not instantiate url")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        let parameters: HTTPParam = [
            "userId": 1,
            "name": "Sunil"
        ]
        
        do {
            let encoder = URLParamEncoder()
            try encoder.encode(urlRequest: &urlRequest, with: parameters)
            guard let fullURL = urlRequest.url else {
                XCTAssertTrue(false, "URLRequest url is nil.")
                return
            }
            
            let expectedURL = "https://www.example.com/?name=Sunil&userId=1"
            XCTAssertEqual(fullURL.absoluteString.sorted(), expectedURL.sorted())
        } catch {
            XCTAssertTrue(false, "URL encoder throws unexpected error")
        }
    }
}
