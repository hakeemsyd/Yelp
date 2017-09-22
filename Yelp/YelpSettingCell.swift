//
//  YelpSettingCell.swift
//  Yelp
//
//  Created by Syed Hakeem Abbas on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class YelpSettingCell: UITableViewCell {

    @IBOutlet weak var settingNameView: UILabel!
    @IBOutlet weak var settingValView: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
