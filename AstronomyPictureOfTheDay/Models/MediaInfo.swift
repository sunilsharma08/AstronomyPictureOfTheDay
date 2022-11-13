//
//  PictureInfo.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 10/11/22.
//

import Foundation

enum MediaType: String, Codable {
    case image
    case video
}

protocol Media: Codable {
    var thumnailUrl: String? { get set }
    var url: String? { get set }
}

struct ImageInfo: Media {
    var thumnailUrl: String?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case thumnailUrl = "url"
        case url = "hdurl"
    }
}

struct VideoInfo: Media {
    var thumnailUrl: String?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case thumnailUrl = "thumbnail_url"
        case url = "url"
    }
}

class MediaInfo: Codable {
    
    let mediaType: MediaType
    var title: String?
    var dateString: String?
    var explanation: String?
    var media: Media?
    var isFavorite: Bool = false
    
    init(mediaType: MediaType) {
        self.mediaType = mediaType
    }
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case title
        case explanation
        case dateString = "date"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.mediaType, forKey: .mediaType)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.explanation, forKey: .explanation)
        try container.encode(self.dateString, forKey: .dateString)
        if mediaType == .image, let imageInfo = media as? ImageInfo {
            try imageInfo.encode(to: encoder)
        } else if mediaType == .video, let videoInfo = media as? VideoInfo {
            try videoInfo.encode(to: encoder)
        }
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.mediaType = try container.decode(MediaType.self, forKey: .mediaType)
        self.title = try container.decode(String.self, forKey: .title)
        self.explanation = try container.decode(String.self, forKey: .explanation)
        self.dateString = try container.decode(String.self, forKey: .dateString)
        if mediaType == .image {
            self.media = try ImageInfo.init(from: decoder)
        } else if mediaType == .video {
            self.media = try VideoInfo.init(from: decoder)
        }
    }
    
}
