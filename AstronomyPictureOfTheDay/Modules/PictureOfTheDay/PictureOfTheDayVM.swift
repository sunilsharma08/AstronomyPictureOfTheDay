//
//  PictureOfTheDayVM.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 10/11/22.
//

import Foundation

class PictureOfTheDayVM {
    
    var dataList: [MediaInfo] = []
    
    lazy var apiHandler: PIctureOfTheDayAPIHandler = PIctureOfTheDayAPIHandler()
    lazy var favPersistance: FavoriteMediaRepository = CDFavoriteMediaRepository()
    lazy var mediaCache: MediaInfoCacheRepository = UDMediaRepository()
    
    /**
     Fetch astronomy picture of the day and update `dataList`.
     When data is fetched successfully it cache data so that it can be used
     when network is unavailable.
     In case network is unavailable it loads last cached data.
     */
    func getPictureOfTheDay(completion: @escaping(_ status: Bool, _ errorMsg: String?) -> Void) {
        self.apiHandler.getPictureOfTheDay {[weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let mediaInfoList):
                self.dataList = mediaInfoList
                self.updateFavoriteFlag()
                if let mediaInfo = mediaInfoList.first {
                    self.mediaCache.create(mediaInfo: mediaInfo)
                }
                completion(true, nil)
            case .failure(let error):
                switch error {
                case NetworkError.noInternet:
                    self.getCachedMediaInfo { status in
                        if status {
                            let errorMsg = "\(error.localizedDescription)\nLoading last cached data"
                            completion(true, errorMsg)
                        } else {
                            completion(false, error.localizedDescription)
                        }
                    }
                default:
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
    
    /**
     Search astronomy picture of the day for the given date
     - parameter date: Date for which astronomy picture will be searched
     */
    func search(date: Date, completion: @escaping(_ status: Bool, _ errorMsg: String?) -> Void) {
        apiHandler.search(date: date) {[weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let mediaInfoList):
                self.dataList = mediaInfoList
                self.updateFavoriteFlag()
                if let mediaInfo = mediaInfoList.first {
                    self.mediaCache.create(mediaInfo: mediaInfo)
                }
                completion(true, nil)
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    /// Update favorite flag for all present data list
    func updateFavoriteFlag() {
        self.dataList.forEach { mediaInfo in
            if let _ = favPersistance.get(byDate: mediaInfo.dateString ?? "") {
                mediaInfo.isFavorite = true
            } else {
                mediaInfo.isFavorite = false
            }
        }
    }
    
    func clearData() {
        self.dataList.removeAll()
    }
    
    func saveFavorite(mediaInfo: MediaInfo) {
        favPersistance.create(mediaInfo: mediaInfo)
    }
    
    func deleteFavorite(mediaInfo: MediaInfo) {
        favPersistance.delete(mediaInfo: mediaInfo)
    }
    
    /// Fetch latest cached atronomy picture details from local DB
    func getCachedMediaInfo(completion: (_ status: Bool) -> Void) {
        if let result = self.mediaCache.getAll(),
            result.isEmpty == false {
            self.dataList = result
            completion(true)
        } else {
            completion(false)
        }
    }
    
}
