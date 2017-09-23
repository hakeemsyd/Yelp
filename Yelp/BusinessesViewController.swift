//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import MapKit

enum SearchDisplayMode{
    case APPEND, RESET
}

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FiltersViewDelegate, CLLocationManagerDelegate {
    
    let PAGE_SIZE = 4
    var searchInProgress: AFHTTPRequestOperation!
    var businesses: [Business] = [Business]()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var isMoreDataLoading = false
    let locationManager = CLLocationManager()
    // SFO Locartion by default : 37.785771,-122.406165
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.785771, longitude: -122.406165)
    
    var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // nav bar styling
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.71, green:0.16, blue:0.09, alpha:1.0)
        searchBar = UISearchBar()
        navigationItem.titleView = searchBar

        // pull to refresh
        refreshControl.addTarget(self, action: #selector(onUserInitiatedRefresh(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // infinite scroll
        let tableFooterView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        self.tableView.tableFooterView = tableFooterView
        
        // bootstrap tableview
        tableView.delegate = self
        searchBar.delegate = self
        tableView.dataSource = self
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        update(mode: SearchDisplayMode.RESET)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(businesses.count - indexPath.row <= PAGE_SIZE && !self.isMoreDataLoading){
            self.isMoreDataLoading = true;
            loadingView.startAnimating()
            update(mode: SearchDisplayMode.APPEND)
        }
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.update(with: businesses[indexPath.row])
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        update(mode: SearchDisplayMode.RESET)
    }
    
    private func update(mode: SearchDisplayMode){
        if(self.searchInProgress != nil && self.searchInProgress.isExecuting){
            self.searchInProgress.cancel()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let param = self.getSearchParameters()
        
        self.searchInProgress =
            Business.searchWithTerm(term: searchBar.text ?? "", limit: PAGE_SIZE, offset: businesses.count, parameters: param, completion: {
                (businesses: [Business]?, error: Error?) -> Void in
                        if( mode == SearchDisplayMode.APPEND) {
                            self.businesses += businesses ?? []
                        } else if( mode == SearchDisplayMode.RESET) {
                            self.businesses = businesses ?? []
                        }
            
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                        self.isMoreDataLoading = false;
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        /*if let businesses = businesses {
                        for business in businesses {
                            print(business.name!)
                            print(business.address!)
                        }
            
                }*/
        })
    }

    func onUserInitiatedRefresh(_ refreshControl: UIRefreshControl) {
        update(mode: SearchDisplayMode.RESET)
    }
    
    final func onFiltersDone(controller: FiltersViewController) {
        update(mode: SearchDisplayMode.RESET)
    }
    
    func getSearchParameters() -> [String: String] {
        var parameters: [String: String] = [String: String]()
        parameters = [
            "ll": "\(userLocation.latitude),\(userLocation.longitude)"
        ]
        for (key, value) in YelpFilters.instance.parameters {
            parameters[key] = value
        }
        return parameters
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = (manager.location?.coordinate)!
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
