//
//  ItunesSearchModel.swift
//  AdKnowledge-iOS
//
//  Created by Jose Montiel on 12/9/16.
//  Copyright © 2016 Jose Montiel. All rights reserved.
//

import Foundation
import Alamofire

class ItunesSearchDelegate {
    
    
    /*
     Queries iTunes Store.

     queryTerm: Term to be searched.
     queryCountry: iTunes store Locale to be queried.
     
     return DataResponse<[StoreItem]> Callback method to be executed.
     */
    public func queryItunes(queryTerm: String, queryCountry:
        String = "US", responseHandler : @escaping ((DataResponse<[StoreItem]>) -> Void)) -> Bool {
        
        let queryTerm = queryTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! as String;

        let request = "https://itunes.apple.com/search?term=\(queryTerm)&country=\(queryCountry)";
    
        Alamofire.request(request, encoding: JSONEncoding.default).responseCollection(completionHandler: responseHandler);
        
        return true;
    }
}
