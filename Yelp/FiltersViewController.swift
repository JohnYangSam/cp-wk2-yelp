//
//  FiltersViewController.swift
//  Yelp
//
//  Created by John YS on 4/20/15.
//  Copyright (c) 2015 John YS. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate {
    func addSearchFilter(controller: FiltersViewController, category: String, sort: Int, radius: Int, deals: Bool)
}

class FiltersViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate /*, UITableViewDataSource, UITableViewDelegate */ {
    
    // Outlets
    @IBOutlet weak var dealSwitch: UISwitch!
    @IBOutlet weak var hikingSwitch: UISwitch!
    @IBOutlet weak var foodSwitch: UISwitch!
    @IBOutlet weak var dentistsSwitch: UISwitch!
    
    @IBOutlet weak var bestMatchLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var highestRatedLabel: UILabel!
   
    @IBOutlet weak var oneMileLabel: UILabel!
    @IBOutlet weak var fiveMileLabel: UILabel!
    @IBOutlet weak var tenMileLabel: UILabel!
    
    var categoriesSwitches:[UISwitch] = []
    var sortLabels:[UILabel] = []
    var mileLabels:[UILabel] = []
    
    // Instance vars
    var deals: Bool! = false
    var distance: Int! = 0
    var sort: Int! = 0
    var categories = ""
    //var categories: [String:String]! = Dictionary<String, String>()
    
    // Delegate
    var delegate: FiltersViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.tableView.dataSource = self
        //self.tableView.delegate = self
        
        deals = dealSwitch.on
        
        // Initialize labels
        categoriesSwitches = [hikingSwitch, foodSwitch, dentistsSwitch]
        sortLabels = [bestMatchLabel, distanceLabel, highestRatedLabel]
        mileLabels = [oneMileLabel, fiveMileLabel, tenMileLabel]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Update switch variable on switch
    
    @IBAction func onDealSwitchChanged(sender: AnyObject) {
        println(dealSwitch.on)
        deals = dealSwitch.on
    }
    
    @IBAction func onSearchPressed(sender: UIBarButtonItem) {
        
        var categoriesArray = ["", "", ""]
        
        if (hikingSwitch.on) { categoriesArray[0] = "hiking" }
        if (foodSwitch.on) { categoriesArray[1] = "food" }
        if (dentistsSwitch.on) { categoriesArray[2] = "dentists" }
       
        var first: Bool = true
        categories = ""
        for category: String in categoriesArray {
            if category != "" {
                if first == true {
                    first = false
                    categories += category
                } else {
                    categories += ","
                    categories += category
                }
            }
        }
        
        delegate.addSearchFilter(self, category: categories, sort: sort, radius: distance, deals: deals)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        // Sort
        if indexPath.section == 1 {
            
            for l: UILabel in sortLabels {
                l.textColor = UIColor.blackColor()
            }
            var label: UILabel = sortLabels[indexPath.row]
            label.textColor = UIColor.blueColor()
            
            if indexPath.row == 0 {
                sort = 0
            } else if indexPath.row == 1 {
                sort = 1
            } else if indexPath.row == 2 {
                sort = 2
            }
            
        } else if indexPath.section == 2 {
            // Radius
            for l: UILabel in mileLabels {
                l.textColor = UIColor.blackColor()
            }
            var label: UILabel = mileLabels[indexPath.row]
            label.textColor = UIColor.blueColor()
            
            if indexPath.row == 0 {
                distance = 1
            } else if indexPath.row == 1 {
                distance = 5
            } else if indexPath.row == 2 {
                distance = 10
            }
        }
        // So that it doesn't stay selected
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // So that we do not highlight the cell
        return nil
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
