//
//  FavoriteMediaListVMTests.swift
//  AstronomyPictureOfTheDayTests
//
//  Created by Sunil Sharma on 13/11/22.
//

import XCTest
@testable import AstronomyPictureOfTheDay

class FavoriteMediaListVMTests: XCTestCase {

    var favMediaVM: FavoriteMediaListVM!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        favMediaVM = FavoriteMediaListVM()
        favMediaVM.favPersistance = MockFavMediaRepo()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        favMediaVM = nil
    }

    func testGetFavMedia() throws {
        
        favMediaVM.getFavMedia { status, errorMsg in
            XCTAssertFalse(status, "Wrong status - Expected false")
        }
        
        XCTAssert(favMediaVM.dataList.count == 0, "Found incorrect data in favorite mediaInfo list")
        
        let mediaInfo1 = MediaInfo(mediaType: .image)
        mediaInfo1.dateString = "2016-03-19"
        
        let mediaInfo2 = MediaInfo(mediaType: .image)
        mediaInfo2.dateString = "2016-03-20"
        
        favMediaVM.favPersistance.create(mediaInfo: mediaInfo1)
        favMediaVM.favPersistance.create(mediaInfo: mediaInfo2)
        
        favMediaVM.getFavMedia { status, errorMsg in
            XCTAssertTrue(status, "Wrong status - Expected true")
        }
        
        XCTAssert(favMediaVM.dataList.count == 2, "Found incorrect data in favorite mediaInfo list")
    }
    
    func testDeleteFavorite() {
        let mediaInfo1 = MediaInfo(mediaType: .image)
        mediaInfo1.dateString = "2016-03-19"
        
        let mediaInfo2 = MediaInfo(mediaType: .image)
        mediaInfo2.dateString = "2016-03-20"
        
        favMediaVM.favPersistance.create(mediaInfo: mediaInfo1)
        favMediaVM.favPersistance.create(mediaInfo: mediaInfo2)
        
        favMediaVM.getFavMedia { status, errorMsg in
            XCTAssertTrue(status, "Wrong status - Expected true")
        }
        favMediaVM.deleteFavorite(mediaInfo: mediaInfo1)
        
        XCTAssert(favMediaVM.dataList.count == 1, "Failed to delete MediaInfo from favorite list")
    }
    
    class MockFavMediaRepo: FavoriteMediaRepository {
        
        var mockDB: [MediaInfo] = []
        
        func create(mediaInfo: MediaInfo) {
            mockDB.append(mediaInfo)
        }
        
        func getAll() -> [MediaInfo]? {
            if mockDB.isEmpty {
                return nil
            }
            return mockDB
        }
        
        func get(byDate dateStr: String) -> MediaInfo? {
            
            if let index = getIndexFor(dateStr: dateStr) {
                return mockDB[index]
            }
            
            return nil
        }
        
        func update(mediaInfo: MediaInfo) {
            if let index = getIndexFor(dateStr: mediaInfo.dateString) {
                let existingMI = mockDB[index]
                existingMI.title = mediaInfo.title
                existingMI.explanation = mediaInfo.explanation
                existingMI.isFavorite = mediaInfo.isFavorite
                existingMI.dateString = mediaInfo.dateString
                existingMI.media = mediaInfo.media
            }
        }
        
        func delete(mediaInfo: MediaInfo) {
            if let index = getIndexFor(dateStr: mediaInfo.dateString) {
                mockDB.remove(at: index)
            }
        }
        
        func getIndexFor(dateStr: String?) -> Int? {
            if let dateStr = dateStr {
                for (index, mediaInfo) in mockDB.enumerated() {
                    if mediaInfo.dateString == dateStr {
                        return index
                    }
                }
                return nil
            } else {
                return nil
            }
        }
    }

}
