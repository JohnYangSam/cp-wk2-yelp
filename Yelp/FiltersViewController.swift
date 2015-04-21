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

class FiltersViewController: UIViewController /*, UITableViewDataSource, UITableViewDelegate */ {
    
    // Outlets
    @IBOutlet weak var dealSwitch: UISwitch!
    
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Update switch variable on switch
    @IBAction func onSwitchChanged(sender: AnyObject) {
        deals = dealSwitch.on
    }

    @IBAction func onCancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onSearchButtonPressed(sender: UIBarButtonItem) {
        // would normally need to set up everything here
        
        delegate.addSearchFilter(self, category: categories, sort: sort, radius: distance, deals: deals)
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
