//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    func searchWithTerm(term: String, category: String, sort: Int, radius: Int, deals: Bool, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        var params = NSDictionary()
        if (radius == -1) {
            // Hard code Stanford location
            params = ["term": term, "ll": "37.4225,-122.1653", "cateogry_filter": category, "sort": sort, "deals_filter": deals]
        }
        else {
            var meters = radius * 1609
            params = ["term": term, "ll": "37.4225,-122.1653", "cateogry_filter": category, "sort": sort, "deals_filter": deals, "raidus": meters]
        }
        return self.GET("search", parameters: params, success: success, failure: failure)
    }
}


