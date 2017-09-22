//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Syed Hakeem Abbas on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

struct Preference {
    var name: String = ""
    var settings: [(key: String, val: Bool)] = [(key: String, val: Bool)]()
    
    init(name: String, settings: [(key: String, val: Bool)]){
        self.name = name
        self.settings = settings
    }
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    /*var settings: [String: [String: Bool]] =
                    ["" : ["Offering a deal": false],
                    "Distance" : ["auto": false, "0.3 miles": false, "0.1 miles": false, "1": false, "5": false, "20": false],
                    "Sort By": ["Best matches": false, "Distance": false, "Highest rated": false],
                    "Category": ["Afghan": false, "African":false, "American": false]]*/
    var settings: [Preference] = []
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.71, green:0.16, blue:0.09, alpha:1.0)
        if let currSettings = defaults.object(forKey: Helper.KEY_SEARCH_SETTINGS) as? [Preference] {
            settings = currSettings
        } else {
            settings = Helper.defaultSettings()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func onSave(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settings[section].name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YelpSetting", for: indexPath) as!
            YelpSettingCell
        
        cell.settingNameView.text = settings[indexPath.section].settings[indexPath.row].key
        cell.settingValView.isOn = settings[indexPath.section].settings[indexPath.row].val
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
