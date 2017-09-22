//
//  YelpSettingCell.swift
//  Yelp
//
//  Created by Syed Hakeem Abbas on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

// #1: Declare the delegate protocol
//the @objc is needed here for the protocol to work
@objc protocol SettingCellDelegate {
    //defining delegate functions
    func settingSwitchChanged(settingCell: YelpSettingCell, switchIsOn: Bool)
}

class YelpSettingCell: UITableViewCell {

    @IBOutlet weak var settingNameView: UILabel!
    @IBOutlet weak var settingValView: UISwitch!
    var sectionName = ""
    weak var delegate: SettingCellDelegate?
    var cellIdx = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Initialization code
        settingValView.addTarget(self, action: #selector(switchValueChanged(filterSwitch:)), for: .valueChanged)
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchValueChanged(filterSwitch: UISwitch) {
        // #3: Call the delegate function
        delegate?.settingSwitchChanged(settingCell: self, switchIsOn: filterSwitch.isOn)
    }

}
