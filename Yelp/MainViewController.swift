//
//  MainViewController.swift
//  Yelp
//
//  Created by John YS on 3/20/15.
//  Copyright (c) 2015 John YS. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Instance vars
    var searchBar: UISearchBar!
    
    // Yelp client
    var client: YelpClient!
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    
    // Yelp results
    var results: [NSDictionary] = []
    
    
    // General Functions
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Dynamically add the search bar
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "e.g. Food near Palo Alto"
        
        // Add the search bar to the title
        self.navigationItem.titleView = searchBar
        
        // Setup tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        // Set automatic row height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        // Set up the Yelp Client
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        
        // For testing
        self.executeSearch(searchBar.text, category: "", sort: 0, radius: 0, deals: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // SearchBar Functions
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // Clear results
        clearResults()
        // Execute search
        self.executeSearch(searchBar.text, category: "", sort: 0, radius: 0, deals: false)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") { clearResults() }
    }
    
    // Search Helper Functions
    func clearResults() {
        results = []
        self.tableView.reloadData()
    }
    
    func executeSearch(searchString: String, category: String, sort: Int, radius: Int, deals: Bool) {
        searchBar.text = searchString
        //println("*********")
        //println(searchParameters)
        //println("*********")
        client.searchWithTerm(searchString, category: category, sort: sort, radius: radius, deals: deals, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            // For debug
            //println(response)
            
            // Get the results
            self.results = response["businesses"] as! [NSDictionary]
            
            // Debug
            println(self.results)
            
            // Reload the tableView Data
            self.tableView.reloadData()
            
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
        }
        
    }
    
    func addSearchFilter(controller: FiltersViewController, category: String, sort: Int, radius: Int, deals: Bool) {
        self.executeSearch(searchBar.text, category: category, sort: sort, radius: radius, deals: deals)
    }
    
    // TableView Functions
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultCell") as! ResultCell
        
        let result: NSDictionary = results[indexPath.row]
        
        println(result)
        
        if (result["image_url"] != nil) {
            cell.businessImage.setImageWithURL(NSURL(string: result["image_url"] as! String))
            println(result["image_url"] as! String)
        }
        
        let reviewCount = result["review_count"] as! Int
        if (reviewCount == 1) {
            cell.reviews.text = "\(reviewCount) review"
        } else {
            cell.reviews.text = "\(reviewCount) reviews"
        }
        
        cell.businessName.text = result["name"] as! String
        
        let addressArray = result.valueForKeyPath("location.display_address") as! Array<String>
        cell.address.text = " ".join(addressArray as! Array<String>)
        
        if let dist = result["distance"] as? Double {
            let miles = dist / 1609.34
            cell.distance.text = String(format: "%.02f", miles) + " mi"
        }
        
        cell.ratingImage.setImageWithURL(NSURL(string: result["rating_img_url"] as! String))
        
        let categoriesArray = result.valueForKeyPath("categories") as! Array<Array<String>>
        cell.categories.text = ", ".join(categoriesArray.map({$0[0]}))
        
        var costString: String = ""
        let costRating = result.valueForKeyPath("rating") as? Int
        if costRating != nil {
            for (var index = 0; index < costRating; ++index) {
                costString += "$"
            }
        }
        
        cell.cost.text = costString
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(results.count)
        return results.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "MainToFilter") {
            let navigationVC = segue.destinationViewController as! UINavigationController
            let filtersVC = navigationVC.viewControllers[0] as! FiltersViewController
            filtersVC.delegate = self
        }
    }

}

