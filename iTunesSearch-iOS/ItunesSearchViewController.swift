//
//  ItunesSearchViewController.swift
//  AdKnowledge-iOS
//
//  Created by Jose Montiel on 12/9/16.
//  Copyright © 2016 Jose Montiel. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire

class ItunesSearchViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchController: ItunesSearchController!;
    
    var storeItemsArray: [StoreItem]?;

    var searchTimer: Timer = Timer.init();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.activityIndicator.center = self.view.center;
        
        self.searchController = ItunesSearchController.init(viewController: self);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onSearchResults(storeItems: [StoreItem]) {
        self.storeItemsArray = storeItems;
        self.activityIndicator.stopAnimating();
        self.tableView.reloadData();
        
        if (storeItems.isEmpty) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
        } else {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine;

        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (storeItemsArray != nil) ? storeItemsArray!.count : 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Getting the right element
        let item = (storeItemsArray?[indexPath.row])!
        
        // Instantiate a cell
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! StoreItemCell;
        
        // Adding the right informations
        cell.titleLabel?.text = item.trackName;
        cell.subtitleLabel?.text = item.artistName;
        cell.kindLabel?.text = item.getKind();
        
        let imageView = cell.trackImageView!;
        imageView.image = nil;
        
        let url = URL(string: item.artworkUrl!)!
        
        imageView.af_setImage(withURL: url);
    
        
        // Returning the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = (self.storeItemsArray?[indexPath.item])!;
        
        searchController.onItemSelected(selectedItem: selectedItem);

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchTimer.isValid) {
            searchTimer.invalidate();
        }
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { _ in
            self.performSearch();
        });
    }
    
    func performSearch() {
        let query: String = self.searchBar.text!;
        if (self.searchController != nil && !query.isEmpty) {
            self.searchController.queryItunes(term: query) ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating();
        } else {
            onSearchResults(storeItems: []);
        }
    }
}
