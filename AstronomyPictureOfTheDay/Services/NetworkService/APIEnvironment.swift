//
//  APIEnvironment.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 10/11/22.
//

import Foundation

/**
 Enum to map with build different build configuration for network APIs
 */
enum APIEnvironment: String {
    case debug
    case release
    
    // MARK: - Current Configuration
    static var current: APIEnvironment {
        return AppConfiguration.shared.apiEnvironment
    }
    
}
