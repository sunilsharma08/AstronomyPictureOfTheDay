//
//  DateSearchVMTests.swift
//  AstronomyPictureOfTheDayTests
//
//  Created by Sunil Sharma on 13/11/22.
//

import XCTest
@testable import AstronomyPictureOfTheDay

class DateSearchVMTests: XCTestCase {

    var dateSearchVM: DateSearchVM!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dateSearchVM = DateSearchVM()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dateSearchVM = nil
    }

    func testDatePickerMinDate() throws {
        
        guard let minDate = dateSearchVM.datePickerMinDate()
        else {
            XCTAssert(false, "ViewModel failed to create datePicker min date instance")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let minDateString = dateFormatter.string(from: minDate)
        let expectedMinDateString = "16-06-1995"
        XCTAssertEqual(minDateString, expectedMinDateString, "DatePicker min date is incorrect")
    }
    
    func testDatePickerMaxDate() throws {
        
        guard let maxDate = dateSearchVM.datePickerMaxDate()
        else {
            XCTAssert(false, "ViewModel failed to create datePicker max date instance")
            return
        }
        let expectedMaxDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let maxDateString = dateFormatter.string(from: maxDate)
        let expectedMaxDateString = dateFormatter.string(from: expectedMaxDate)
        XCTAssertEqual(maxDateString, expectedMaxDateString, "DatePicker max date is incorrect")
    }

}
