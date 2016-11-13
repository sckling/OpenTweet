//
//  TweetThreadViewController.swift
//  OpenTweet
//
//  Created by Stephen Ling on 11/13/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

class TweetThreadViewController : UITableViewController {
    
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tweets"
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineViewCell", for: indexPath) as! TimelineViewCell
        let tweet = self.tweets[indexPath.row]
        cell.author.text = tweet.author
        cell.date.text = tweet.date
        cell.content.attributedText = tweet.content
        return cell
    }

}
