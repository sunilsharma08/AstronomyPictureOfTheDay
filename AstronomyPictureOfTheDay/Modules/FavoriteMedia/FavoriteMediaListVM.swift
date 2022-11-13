//
//  FavoriteMediaListVM.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 12/11/22.
//

import Foundation

class FavoriteMediaListVM {
    
    var dataList: [MediaInfo] = []
    lazy var favPersistance: FavoriteMediaRepository = CDFavoriteMediaRepository()
    
    /// Fetch all favorite astronomy picture details from local db
    func getFavMedia(completion: @escaping (_ status: Bool, _ errorMsg: String?) -> Void) {
        let result = favPersistance.getAll()
        
        if let mediaInfoList = result {
            self.dataList = mediaInfoList
            completion(true, nil)
        } else {
            self.dataList.removeAll()
            completion(false, nil)
        }
    }
    
    /// Delete astronomy picture from favorite list
    /// - parameter mediaInfo: mediaInfo to be deleted
    func deleteFavorite(mediaInfo: MediaInfo) {
        
        dataList.removeAll { mediaData in
            if mediaData === mediaInfo {
                return true
            } else {
                return false
            }
        }
        favPersistance.delete(mediaInfo: mediaInfo)
    }
    
}
