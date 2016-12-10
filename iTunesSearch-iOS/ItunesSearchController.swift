//
//  ItunesSearchController.swift
//  AdKnowledge-iOS
//
//  Created by Jose Montiel on 12/9/16.
//  Copyright © 2016 Jose Montiel. All rights reserved.
//

import Foundation
import UIKit

class ItunesSearchController {
    
    var viewController : ItunesSearchViewController;
    var searchDelegate : ItunesSearchDelegate;
    
    init(viewController : ItunesSearchViewController) {
        self.viewController = viewController;
        self.searchDelegate = ItunesSearchDelegate.init();
    }
    
    public func queryItunes(term : String) -> Bool {
        return searchDelegate.queryItunes(queryTerm: term, responseHandler: { response in
            debugPrint(response);// result of response serialization
        
            
            if let items = response.result.value {
                self.viewController.onSearchResults(storeItems: items);
            }
            
        });
    }
    
    func onItemSelected(selectedItem: StoreItem) {
        let url = URL(string: (selectedItem.viewUrl)! as String)!;
        print("SELECTED: \(url)");
        
        if (TARGET_IPHONE_SIMULATOR != 0) {
            print("Trying to open on simulator");
        } else {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        ClickTrackingDelegate.trackClick(item: selectedItem);
    }
}
