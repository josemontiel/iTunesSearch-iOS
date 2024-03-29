//
//  ClickTrackingDelegate.swift
//  AdKnowledge-iOS
//
//  Created by Jose Montiel on 12/9/16.
//  Copyright © 2016 Jose Montiel. All rights reserved.
//

import Foundation
import Alamofire


final class ClickTrackingDelegate {
    
    static public var EVENT_URL = "https://itunessearch.herokuapp.com/api/event";

    /*
     Sends a POST request to our backend indicating a Click event on a StoreItem has occurred.
     */
    public static func trackClick(item: StoreItem) {
        
        // Unique Device Id. Needed for "Per User" tracking.
        let uniqueId=UIDevice.current.identifierForVendor!.uuidString;


        let parameters: Parameters = [
            "trackId": item.trackId as Any,
            "artistId": item.artistId as Any,
            "timestamp": Date.init().timeIntervalSince1970,
            "deviceId": uniqueId
        ];
        
        Alamofire.request(EVENT_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).response(completionHandler: { response in
            debugPrint(response);
        });

    }
}
