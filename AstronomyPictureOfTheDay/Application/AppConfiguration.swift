//
//  AppConfiguration.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 10/11/22.
//

import Foundation

/**
 Perform configuration which will be used throughout the app
 */
class AppConfiguration {
    
    static let shared = AppConfiguration()
    
    var apiEnvironment: APIEnvironment = {
        /// Get configuration from bundle like Debug, Release, etc
        guard let rawValue = Bundle.main.infoDictionary?["Configuration"] as? String else {
            fatalError("No Configuration Found")
        }
        
        /// Initiate API env according to configuration
        guard let configuration = APIEnvironment(rawValue: rawValue.lowercased()) else {
            fatalError("Invalid Configuration")
        }
        
        return configuration
    }()
    
    private init() {}
}
