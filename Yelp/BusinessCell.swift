//
//  BusinessCell.swift
//  Yelp
//
//  Created by Syed Hakeem Abbas on 9/20/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

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

}
