//
//  Tweet.swift
//  OpenTweet
//
//  Created by Stephen Ling on 11/6/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import Foundation

struct Tweet {
    let id: String
    let author: String
    let content: String
    let date: String
    var inReplyTo: String?
    var avatar: String?
}

extension Tweet {
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String,
            let author = json["author"] as? String,
            let content = json["content"] as? String,
            let dateString = json["date"] as? String
        else {
            return nil
        }
        self.id = id
        self.author = author
        self.content = content
        self.date = dateString.shortDateString()

        if let inReplyTo = json["inReplayTo"] as? String {
            self.inReplyTo = inReplyTo
        }
        if let avatar = json["avatar"] as? String {
            self.avatar = avatar
        }
    }
}

extension String {
    func shortDateString() -> String {
        // 2016-09-30T09:41:00-08:00
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.ReferenceType.local
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        let startDate = formatter.date(from: self)
        
        let shortFormat = DateFormatter()
        shortFormat.dateStyle = DateFormatter.Style.short
        shortFormat.timeStyle = .short
        let timeString = shortFormat.string(from: startDate!)
        return timeString
    }
}

extension Tweet {
    static func tweets(completion: @escaping ([Tweet]) -> Void) {
        DataManager.loadDataFromFile { data in
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] {
                var tweets = [Tweet]()
                for case let result in json["timeline"] as! [[String:Any]] {
                    if let tweet = Tweet(json: result) {
                        tweets.append(tweet)
                    }
                }
                completion(tweets)
            }
        }
    }
}

