//
//  PictureOfTheDayVMTests.swift
//  AstronomyPictureOfTheDayTests
//
//  Created by Sunil Sharma on 13/11/22.
//

import XCTest
@testable import AstronomyPictureOfTheDay

class PictureOfTheDayVMTests: XCTestCase {

    var potdViewModel: PictureOfTheDayVM!
    let router = MockRouter()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let potdAPIHandler = PIctureOfTheDayAPIHandler(router: router)
        self.potdViewModel = PictureOfTheDayVM()
        self.potdViewModel.apiHandler = potdAPIHandler
        self.potdViewModel.mediaCache = MockMediaCache()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.potdViewModel = nil
    }

    /// Test fetch picture of the day api return success response
    func testGetPictureOfTheDaySuccess() throws {
        let successResponse = HTTPURLResponse(url: URL(string: "http://www.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        router.mockData = (mockJSONData(), successResponse, nil)
        
        let expectation = self.expectation(description: "Fetch Astronomy picture of the day")
        var respStatus: Bool = false
        
        potdViewModel.getPictureOfTheDay { status, errorMsg in
            respStatus = status
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertTrue(respStatus, "Incorrect fetch status")
        XCTAssertTrue(self.potdViewModel.dataList.count == 1, "Failed to assign data")
    }
    
    /// Test fetch picture of the day api return failure response
    func testGetPictureOfTheDayFailure() throws {
        let failureResponse = HTTPURLResponse(url: URL(string: "http://www.example.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)
        router.mockData = (nil, failureResponse, NetworkError.authenticationError)
        
        let expectation = self.expectation(description: "Fetch Astronomy picture of the day")
        var respStatus: Bool = true
        
        potdViewModel.getPictureOfTheDay { status, errorMsg in
            respStatus = status
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertTrue(respStatus == false, "Incorrect fetch status")
        XCTAssertTrue(self.potdViewModel.dataList.count == 0, "Incorrect data on api failure")
    }
    
    // Test success case of search api
    func testSearchSuccess() {
        
        let successResponse = HTTPURLResponse(url: URL(string: "http://www.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        router.mockData = (mockJSONData(), successResponse, nil)
        
        let expectation = self.expectation(description: "Fetch Astronomy picture of the day")
        var respStatus: Bool = false
        
        potdViewModel.getPictureOfTheDay { status, errorMsg in
            respStatus = status
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertTrue(respStatus, "Incorrect fetch status")
        
        XCTAssertTrue(self.potdViewModel.dataList.count == 1, "Failed to assign data")
    }
    
    func mockJSONData() -> Data {
        let catBreedJson = """
        {
          "date": "2016-03-19",
          "explanation": "Get out your red/blue glasses and gaze across Ceres at mysterious mountain Ahuna Mons. Shown in a 3D anaglyph perspective view, the mosaicked image data was captured in December of 2015, taken from the Dawn spacecraft's low-altitude mapping orbit about 385 kilometers above the surface of the dwarf planet. A remarkable dome-shaped feature on Ceres, with steep, smooth sides Ahuna Mons is about 20 kilometers (12 miles) in diameter at its base, rising on average 4 kilometers to a flattened summit. Similar in size to mountains found on planet Earth, no other Cerean surface feature is so tall and well-defined. It is not known what process shaped the lonely Ahuna Mons, or if the bright material streaking its steepest side is the same material responsible for Ceres' famous bright spots.",
          "hdurl": "https://apod.nasa.gov/apod/image/1603/PIA20349_fig1.jpg",
          "media_type": "image",
          "service_version": "v1",
          "title": "3D Ahuna Mons",
          "url": "https://apod.nasa.gov/apod/image/1603/PIA20349_fig1c1024.jpg"
        }
        """
        let jsonData = catBreedJson.data(using: .utf8)!
        return jsonData
    }

    class MockMediaCache: MediaInfoCacheRepository {
        
        func create(mediaInfo: MediaInfo) {
        }
        
        func getAll() -> [MediaInfo]? {
            return nil
        }
        
        func get(byDate dateStr: String) -> MediaInfo? {
            return nil
        }
        
        func update(mediaInfo: MediaInfo) {
        }
        
        func delete(mediaInfo: MediaInfo) {
        }
        
    }
}

