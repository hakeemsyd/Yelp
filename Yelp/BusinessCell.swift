//
//  BusinessCell.swift
//  Yelp
//
//  Created by Syed Hakeem Abbas on 9/20/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var addressView: UILabel!
    @IBOutlet weak var categoriesView: UILabel!
    @IBOutlet weak var reviewsImageView: UIImageView!
    @IBOutlet weak var reviewCountView: UILabel!
    @IBOutlet weak var howFarView: UILabel!
    @IBOutlet weak var businessNameView: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with business: Business){
        howFarView.text = business.distance
        businessNameView.text = business.name
        reviewCountView.text = "\(business.reviewCount ?? 0) Reviews"
        categoriesView.text = business.categories
        addressView.text = business.address
        if let posterImg = business.imageURL {
            Helper.loadPhoto(withUrl: posterImg, into: displayImageView)
        }
        
        if let ratingImg = business.ratingImageURL {
            Helper.loadPhoto(withUrl: ratingImg, into: reviewsImageView)
        }
    }
}
