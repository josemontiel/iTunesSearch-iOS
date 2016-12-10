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
        
        // Centers the Activity Indicator in the Viewport.
        self.activityIndicator.center = self.view.center;
        
        // Instantiates our SearchController. TODO: Use proper Dependency Injection.
        self.searchController = ItunesSearchController.init(viewController: self);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
     Callback Method when iTunes Searches are completed.
     */
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
    
    //////////////////////////
    // UITableView Methods //
    ////////////////////////
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (storeItemsArray != nil) ? storeItemsArray!.count : 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Getting the StoreItem for the given table view index to populate
        let item = (storeItemsArray?[indexPath.row])!
        
        // Dequeue a Table View Cell
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! StoreItemCell;
        
        // Set StoreItem information into the Cell UI
        cell.titleLabel?.text = item.trackName;
        cell.subtitleLabel?.text = item.artistName;
        cell.kindLabel?.text = item.getKind();
        
        // Load Artwork Asynchronously into our UIImageView
        let imageView = cell.trackImageView!;
        imageView.image = nil;
        let url = URL(string: item.artworkUrl!)!
        imageView.af_setImage(withURL: url);
    
        // Returning the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = (self.storeItemsArray?[indexPath.item])!;
        
        // A StoreItem has been clicked. Notify our Search Controller.
        searchController.onItemSelected(selectedItem: selectedItem);

    }

    //////////////////////////////////
    // UISearchBarDelegate Methods //
    ////////////////////////////////
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // If a Timer with a Delayed Query has already been set, invalidate it.
        if (searchTimer.isValid) {
            searchTimer.invalidate();
        }
        
        // Set a new Timer for our new Query
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { _ in
            // Perform Search
            self.performSearch();
        });
    }
    
    /*
     Performs a new iTunes Search
     */
    func performSearch() {
        // Get Query Term from our UISearchBar
        let query: String = self.searchBar.text!;
        // Chec Controller is still valid and our query term is valid.
        if (self.searchController != nil && !query.isEmpty) {
            // Perform Search and notify our UIActivityIndicator
            self.searchController.queryItunes(term: query) ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating();
        } else {
            // If query is emtpy then remove any items already set by setting an empty collection.
            onSearchResults(storeItems: []);
        }
    }
}
