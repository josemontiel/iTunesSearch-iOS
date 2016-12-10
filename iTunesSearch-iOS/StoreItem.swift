//
//  StoreItem.swift
//  AdKnowledge-iOS
//
//  Created by Jose Montiel on 12/9/16.
//  Copyright © 2016 Jose Montiel. All rights reserved.
//

import Foundation

final class StoreItem : ResponseObjectSerializable, ResponseCollectionSerializable, CustomStringConvertible {
    
    let trackId: Int64;
    let trackName: String;
    let artistName: String;
    let kind: String;
    let viewUrl: String?;
    let artworkUrl: String?;
    
    var description: String {
        return "Item: { trackName: \(trackName), artistName: \(artistName), viewUrl: \(viewUrl) }"
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        
        let representation = representation as? [String: Any];
        let trackId = representation?["trackId"] as? Int64;
        let trackName = representation?["trackName"] as? String;
        let artistName = representation?["artistName"] as? String;
        let kind = representation?["kind"] as? String;
        let viewUrl = representation?["trackViewUrl"] as? String
        let artworkUrl = representation?["artworkUrl100"] as? String
        
        self.trackId = trackId!;
        self.trackName = trackName!;
        self.artistName = artistName!;
        self.kind = kind!;
        self.viewUrl = viewUrl;
        self.artworkUrl = artworkUrl;
    }
    
    func getKind() -> String {
        switch self.kind {
        case "book":
            return "Book";
        case "album":
            return "Album";
        case "coaches-audio":
            return "Coaches Audio";
        case "feature-movie":
            return "Movie";
        case "interactive-booklet":
            return "Interactive Booklet";
        case "music-video":
            return "Music Video";
        case "pdf":
            return "PDF";
        case "podcast":
            return "Podcast";
        case "podcast-episode":
            return "Podcast Episode";
        case "software-package":
            return "Software";
        case "song":
            return "Song";
        case "tv-episode":
            return "TV Episode";
        case "artist":
            return "Artist";
        default:
            return "";
        }
    }

    static func collection(response: HTTPURLResponse, representation: Any) -> [StoreItem] {
        var collection: [StoreItem] = []
        
        if let representation = representation as? [String: Any] {
            if let representation = representation["results"] as? [[String: Any]] {
                for itemRepresentation in representation {
                    if let item = self.init(response: response, representation:     itemRepresentation) {
                        collection.append(item)
                    }
                }
            }
        }
        
        return collection
    }
    
}
