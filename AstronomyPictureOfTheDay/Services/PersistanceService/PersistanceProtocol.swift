//
//  PersistanceProtocol.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 12/11/22.
//

import Foundation

protocol FavoriteMediaRepository {

    func create(mediaInfo: MediaInfo)
    func getAll() -> [MediaInfo]?
    func get(byDate dateStr: String) -> MediaInfo?
    func update(mediaInfo: MediaInfo)
    func delete(mediaInfo: MediaInfo)
}

protocol MediaInfoCacheRepository {

    func create(mediaInfo: MediaInfo)
    func getAll() -> [MediaInfo]?
    func get(byDate dateStr: String) -> MediaInfo?
    func update(mediaInfo: MediaInfo)
    func delete(mediaInfo: MediaInfo)
}


