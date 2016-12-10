//
//  StoreItem.swift
//  AdKnowledge-iOS
//
//  Created by Jose Montiel on 12/9/16.
//  Copyright © 2016 Jose Montiel. All rights reserved.
//

import Foundation

final class StoreItem : ResponseObjectSerializable, ResponseCollectionSerializable, CustomStringConvertible {
    
    // Item's Track Id
    let trackId: Int64?;
    // Item Artist's Id
    let artistId: Int64?;
    // Track Name
    let trackName: String?;
    // Artist Name
    let artistName: String?;
    // Store Item Type
    let kind: String?;
    // iTunes Item's URL
    let viewUrl: String?;
    // Artwork preview URL 100x100
    let artworkUrl: String?;
    
    var description: String {
        return "Item: { trackName: \(trackName), artistName: \(artistName), viewUrl: \(viewUrl) }"
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        
        let representation = representation as? [String: Any];
        let trackId = representation?["trackId"] as? Int64;
        let artistId = representation?["artistId"] as? Int64;
        let trackName = representation?["trackName"] as? String;
        let artistName = representation?["artistName"] as? String;
        let kind = representation?["kind"] as? String;
        let viewUrl = representation?["trackViewUrl"] as? String
        let artworkUrl = representation?["artworkUrl100"] as? String
        
        self.trackId = trackId;
        self.artistId = artistId;
        self.trackName = trackName;
        self.artistName = artistName;
        self.kind = kind;
        self.viewUrl = viewUrl;
        self.artworkUrl = artworkUrl;
    }
    
    /*
     Returns a human readable _Kind_ value.
     */
    func getKind() -> String {
        if (self.kind == nil) {
            return "";
        }
        switch self.kind! {
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

    /*
     Custom Response Deserializer for type StoreItem 
     */
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
