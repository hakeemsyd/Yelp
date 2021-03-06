//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking
import MapKit

class Business: NSObject {
    let name: String?
    let address: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let ratingImageURL: URL?
    let reviewCount: NSNumber?
    var coordinate: CLLocationCoordinate2D?
    
    init(dictionary: NSDictionary) {
        self.coordinate = CLLocationCoordinate2D()
        
        name = dictionary["name"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
            
            let coords = location!["coordinate"] as? NSDictionary
            if coords != nil && (coords?.count)! > 0 {
                let long = coords?["longitude"] as! Double
                let lat = coords?["latitude"] as! Double
                self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            }
        }
        self.address = address
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joined(separator: ", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = URL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
    }
    
    func printBusiness(){
        var str = ""
        str += "\nName: \(name ?? "")\n"
        str += "Address: \(address ?? "")\n"
        str += "Distance: \(distance ?? "")\n"
        print(str)
    }
    
    class func businesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, limit: Int, offset: Int, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        return YelpClient.sharedInstance.searchWithTerm(term, limit, offset, completion: completion)
    }
    
    class func searchWithTerm(term: String, limit: Int, offset: Int, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        return YelpClient.sharedInstance.searchWithTerm(term, limit: limit, offset: offset, sort: sort, categories: categories, deals: deals, completion: completion)
    }
    
    class func searchWithTerm(term: String, limit: Int, offset: Int, parameters: [String: Any],completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
    
        return YelpClient.sharedInstance.searchWithTerm(term, limit: limit, offset: offset, parameters: parameters, completion: completion)
    }
}
