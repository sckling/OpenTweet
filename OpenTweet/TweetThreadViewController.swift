//
//  TweetThreadViewController.swift
//  OpenTweet
//
//  Created by Stephen Ling on 11/13/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

class TweetThreadViewController : UITableViewController, UIGestureRecognizerDelegate {
    
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
        
        let singleTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedContent(gesture:)))
        singleTap.delegate = self
        cell.content.addGestureRecognizer(singleTap)
        cell.content.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.shake()
    }
    
    func tappedContent(gesture: UITapGestureRecognizer) -> Void {
        if let contentView = gesture.view {
            let cell = tableView.cellForRow(at: IndexPath(row: contentView.tag, section: 0))
            cell?.contentView.shake()
        }
    }

}

extension UIView {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }

}
