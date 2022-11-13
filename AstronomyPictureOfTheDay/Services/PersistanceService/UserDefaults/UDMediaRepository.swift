//
//  UDMediaRepository.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 12/11/22.
//

import Foundation

struct UDMediaRepository: MediaInfoCacheRepository {
    
    let latestMediaInfoCacheKey = "com.sunilsharma.latestMediaInfoCache"
    
    func create(mediaInfo: MediaInfo) {
        
        guard let mediaInfoData = try? JSONEncoder().encode(mediaInfo)
        else { return }
        
        UserDefaults.standard.set(mediaInfoData, forKey: latestMediaInfoCacheKey)
    }
    
    func getAll() -> [MediaInfo]? {
        
        guard let mediaInfoData = UserDefaults.standard.data(forKey: latestMediaInfoCacheKey) else { return nil }
        
        let mediaInfo = try? JSONDecoder().decode(MediaInfo.self, from: mediaInfoData)
        if let mediaInfo = mediaInfo {
            return [mediaInfo]
        }
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
