//
//  CDFavoriteMediaRepository.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 12/11/22.
//

import Foundation
import CoreData

struct CDFavoriteMediaRepository: FavoriteMediaRepository {
    
    func create(mediaInfo: MediaInfo) {
        let cdFavorite = CDFavoriteMedia(context: CDPersistanceStorage.shared.context)
        cdFavorite.title = mediaInfo.title
        cdFavorite.explanation = mediaInfo.explanation
        cdFavorite.dateString = mediaInfo.dateString
        cdFavorite.mediaType = mediaInfo.mediaType.rawValue
        cdFavorite.url = mediaInfo.media?.url
        cdFavorite.thumbnailUrl = mediaInfo.media?.thumnailUrl
        
        CDPersistanceStorage.shared.saveContext()
    }
    
    func getAll() -> [MediaInfo]? {
        
        let result = CDPersistanceStorage.shared.fetchManagedObject(managedObject: CDFavoriteMedia.self)
        var mediaInfoList: [MediaInfo] = []
        
        result?.forEach({ cdFavorite in
            if let mediaInfo = convertCDFavtorite(cdFavorite) {
                mediaInfoList.append(mediaInfo)
            }
        })
        
        if mediaInfoList.isEmpty {
            return nil
        } else {
            return mediaInfoList
        }
    }
    
    func get(byDate dateStr: String) -> MediaInfo? {
        
        guard let cdFavMedia = getFavMediaInfo(byDate: dateStr)
        else { return nil }
        
        return convertCDFavtorite(cdFavMedia)
    }
    
    func update(mediaInfo: MediaInfo) {
        
    }
    
    func delete(mediaInfo: MediaInfo) {
        
        guard let dateStr = mediaInfo.dateString,
              let cdFavMedia = getFavMediaInfo(byDate: dateStr)
        else { return }
        
        CDPersistanceStorage.shared.context.delete(cdFavMedia)
        CDPersistanceStorage.shared.saveContext()
        
    }
    
    // Helper methods
    
    func getFavMediaInfo(byDate dateStr: String) -> CDFavoriteMedia? {
        let fetchRequest = NSFetchRequest<CDFavoriteMedia>(entityName: "CDFavoriteMedia")
        let predicate = NSPredicate(format: "dateString==%@", dateStr)
        fetchRequest.predicate = predicate
        do {
            let result = try CDPersistanceStorage.shared.context.fetch(fetchRequest).first
            return result
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    private func convertCDFavtorite(_ cdFavorite: CDFavoriteMedia) -> MediaInfo? {
        if let mediaType = MediaType(rawValue: cdFavorite.mediaType ?? "") {
            let mediaInfo = MediaInfo(mediaType: mediaType)
            mediaInfo.title = cdFavorite.title
            mediaInfo.explanation = cdFavorite.explanation
            mediaInfo.dateString = cdFavorite.dateString
            mediaInfo.isFavorite = true
            if mediaType == .image {
                mediaInfo.media = ImageInfo(thumnailUrl: cdFavorite.thumbnailUrl, url: cdFavorite.url)
            } else {
                mediaInfo.media = VideoInfo(thumnailUrl: cdFavorite.thumbnailUrl, url: cdFavorite.url)
            }
            return mediaInfo
        }
        return nil
    }
}
