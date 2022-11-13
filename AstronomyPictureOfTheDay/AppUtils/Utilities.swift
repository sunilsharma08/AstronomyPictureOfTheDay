//
//  Utilities.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 11/11/22.
//

import Foundation

enum CustomError: LocalizedError {
    case custom(String)
    
    var errorDescription: String? {
        switch self {
        case .custom(let errorMsg):
            return errorMsg
        }
    }
}
