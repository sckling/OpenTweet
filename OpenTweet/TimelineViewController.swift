//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit


class TimelineViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Timeline"
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        loadTweets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadTweets() {
        Tweet.tweets() { tweets in
            DispatchQueue.main.async {
                self.tweets = tweets
                self.tableView.reloadData()
            }
        }
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
        self.performSegue(withIdentifier: "TweetThreadViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TweetThreadViewController", let destination = segue.destination as? TweetThreadViewController {
            if let indexPath = tableView.indexPathForSelectedRow, indexPath.row < tweets.count {
                destination.tweets = tweetThread(from: tweets[indexPath.row])
            }
        }
    }
    
    func tweetThread(from tweet: Tweet) -> [Tweet] {
        if let index = tweets.index(where: {$0.id == tweet.id}) {
            if tweet.inReplyTo == nil {
                let slice = tweets[index..<tweets.count]
                return [Tweet](slice)
            }
            else {
                for i in 0..<index {
                    if tweets[i].id == tweet.inReplyTo {
                        return [tweets[i], tweet]
                    }
                }
            }
        }
        return [tweet]
    }
    
    func tappedContent(gesture: UITapGestureRecognizer) -> Void {
        if let contentView = gesture.view {
            tableView.selectRow(at: IndexPath(row: contentView.tag, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
            self.performSegue(withIdentifier: "TweetThreadViewController", sender: self)
        }
    }

}
