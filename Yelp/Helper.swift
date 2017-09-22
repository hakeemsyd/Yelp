//
//  Helper.swift
//  Yelp
//
//  Created by Syed Hakeem Abbas on 9/20/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit

struct Helper {
    
    static let KEY_SEARCH_SETTINGS = "search_settings"
    static func loadPhoto(withUrl url: URL, into view: UIImageView){
        let imageRequest = URLRequest(url: url)
        view.setImageWith(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    view.alpha = 0.0
                    view.image = image
                    UIImageView.animate(withDuration: 0.3,animations: { () -> Void in
                        view.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    view.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
    }
    
    static func defaultSettings() -> [Preference] {
        return
            [   Preference(name: "" , settings: [("Offering a deal", false)]),
                Preference(name: "Distance", settings: [("Auto", false), ("0.3 miles", false), ("0.1 miles", false), ("1", false), ("5", false), ("20", false)]),
                Preference(name: "Sort By", settings: [("Best matches", false), ("Distance", false), ("Highest rated", false)]),
                Preference(name: "Category", settings: [("Afghan", false), ("African", false), ("American", false)])
            ]
        
            //,
             /*"Distance" : ["auto": false, "0.3 miles": false, "0.1 miles": false, "1": false, "5": false, "20": false],
             "Sort By": ["Best matches": false, "Distance": false, "Highest rated": false],
             "Category": ["Afghan": false, "African":false, "American": false]]*/
        //return [Preference]()
    }
    
}
