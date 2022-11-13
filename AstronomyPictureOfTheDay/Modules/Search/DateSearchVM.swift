//
//  DateSearchVM.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 13/11/22.
//

import Foundation

class DateSearchVM {
    
    /// Returns valid minimum date for DatePicker
    func datePickerMinDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let minDate = dateFormatter.date(from: "16-06-1995")
        return minDate
    }
    
    /// Returns valid maximum date for DatePicker
    func datePickerMaxDate() -> Date? {
        return Date()
    }
    
}
