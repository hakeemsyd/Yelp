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
}
