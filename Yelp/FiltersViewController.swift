//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Syed Hakeem Abbas on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersViewDelegate {
    func onFiltersDone(controller: FiltersViewController)
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var settings: YelpFilters = YelpFilters()
    var delegate: FiltersViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.71, green:0.16, blue:0.09, alpha:1.0)

        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Create a new instance of the model for this "session"
        self.settings = YelpFilters(instance: YelpFilters.instance)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func onSave(_ sender: UIBarButtonItem) {
        //defaults.setValue(settings, forKey: Helper.KEY_SEARCH_SETTINGS)
        //defaults.synchronize()
        YelpFilters.instance.copyStateFrom(instance: self.settings)
        dismiss(animated: true, completion: nil)
        self.delegate?.onFiltersDone(controller: self)
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let filter = self.settings.filters[indexPath.section]
        switch filter.type {
        case .Single:
            if filter.opened {
                let previousIndex = filter.selectedIndex
                if previousIndex != indexPath.row {
                    filter.selectedIndex = indexPath.row
                    let previousIndexPath = IndexPath(row: previousIndex, section: indexPath.section)
                    
                    
                    self.tableView.reloadRows(at: [indexPath, previousIndexPath], with: .automatic)
                }
            }
            
            let opened = filter.opened;
            filter.opened = !opened;
            
            if opened {
                //let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC)))
                // dispatch_after(time, dispatch_get_main_queue(), {
                //self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
                // })
                self.tableView.reloadSections(IndexSet(integersIn: indexPath.section...indexPath.section), with: .automatic)
            } else {
                self.tableView.reloadSections(IndexSet(integersIn: indexPath.section...indexPath.section), with: .automatic)
            }
        case .Multiple:
            if !filter.opened && indexPath.row == filter.numItemsVisible {
                filter.opened = true
                self.tableView.reloadSections(IndexSet(integersIn: indexPath.section...indexPath.section), with: .automatic)
            } else {
                let option = filter.options[indexPath.row]
                option.selected = !option.selected
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }

    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let filter = self.settings.filters[section]
        let label = filter.label
        
        if filter.type == .Multiple && filter.numItemsVisible! > 0 && filter.numItemsVisible! < filter.options.count && !filter.opened {
            //let selectedOptions = filter.selectedOptions
            return label
        }
        
        return label
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.settings.filters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filter = settings.filters[section] as Filter?{
            if !filter.opened {
                if filter.type == FilterType.Single {
                    return 1
                } else if filter.numItemsVisible! > 0 && filter.numItemsVisible! < filter.options.count {
                    return filter.numItemsVisible! + 1
                }
            }
            return filter.options.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*let cell = tableView.dequeueReusableCell(withIdentifier: "YelpSetting", for: indexPath) as!
            YelpSettingCell*/
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        
        let filter = self.settings.filters[indexPath.section] as Filter
        switch filter.type {
        case .Single:
            if filter.opened {
                let option = filter.options[indexPath.row]
                cell.textLabel?.text = option.label
                if option.selected {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Check"))
                } else {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Uncheck"))
                }
            } else {
                cell.textLabel?.text = filter.options[filter.selectedIndex].label
                cell.accessoryView = UIImageView(image: UIImage(named: "Dropdown"))
            }
        case .Multiple:
            if filter.opened || indexPath.row < filter.numItemsVisible! {
                let option = filter.options[indexPath.row]
                cell.textLabel?.text = option.label
                if option.selected {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Check"))
                } else {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Uncheck"))
                }
            } else {
                cell.textLabel?.text = "See All"
                cell.textLabel?.textAlignment = NSTextAlignment.center
                cell.textLabel?.textColor = .darkGray
            }
        default:
            let option = filter.options[indexPath.row]
            cell.textLabel?.text = option.label
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let switchView = UISwitch(frame: CGRect.zero)
            switchView.isOn = option.selected
            switchView.onTintColor = UIColor(red: 73.0/255.0, green: 134.0/255.0, blue: 231.0/255.0, alpha: 1.0)
            switchView.addTarget(self, action: #selector(handleSwitchValueChanged), for: UIControlEvents.valueChanged)
            cell.accessoryView = switchView
        }
        
        return cell
    }
    
    func handleSwitchValueChanged(switchView: UISwitch) -> Void {
        let cell = switchView.superview as! UITableViewCell
        if let indexPath = self.tableView.indexPath(for: cell) {
            let filter = self.settings.filters[indexPath.section] as Filter
            let option = filter.options[indexPath.row]
            option.selected = switchView.isOn
        }
    }
}
