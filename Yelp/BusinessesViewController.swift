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

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var searchInProgress: AFHTTPRequestOperation!
    var businesses: [Business] = [Business]()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var isMoreDataLoading = false
    
    var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.71, green:0.16, blue:0.09, alpha:1.0)
        searchBar = UISearchBar()
        navigationItem.titleView = searchBar

        refreshControl.addTarget(self, action: #selector(onUserInitiatedRefresh(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        /*let tableFooterView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        self.tableView.tableFooterView = tableFooterView*/
        
        tableView.delegate = self
        searchBar.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update(with: searchBar.text!)    /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
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
        if(businesses.count - indexPath.row <= 4 /*&& !self.isMoreDataLoading*/){
            //self.isMoreDataLoading = true;
            //loadingView.startAnimating()
            
            // ... Code to load more results ...
            /*self.fetchData(offset: posts.count,handler: {(data, response, error) in
                self.isMoreDataLoading = false;
                self.loadingView.stopAnimating()
                self.posts += self.parsePosts(data: data)
                self.tableView.reloadData()
            });*/
            
        }
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.update(with: businesses[indexPath.row])
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        update(with: searchText)
    }
    
    private func update(with term: String){
        if(self.searchInProgress != nil && self.searchInProgress.isExecuting){
            self.searchInProgress.cancel()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.searchInProgress =
            Business.searchWithTerm(term: term, completion: { (businesses: [Business]?, error: Error?) -> Void in
                
                self.businesses = businesses ?? []
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.isMoreDataLoading = false;
                
                MBProgressHUD.hide(for: self.view, animated: true)
                if let businesses = businesses {
                    for business in businesses {
                        print(business.name!)
                        print(business.address!)
                    }
                }
                
            }
        )
    }

    func onUserInitiatedRefresh(_ refreshControl: UIRefreshControl) {
        update(with: searchBar.text ?? "")
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
