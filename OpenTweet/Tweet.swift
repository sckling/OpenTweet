//
//  Tweet.swift
//  OpenTweet
//
//  Created by Stephen Ling on 11/6/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

struct Tweet {
    let id: String
    let author: String
    let content: NSAttributedString
    let date: String
    let inReplyTo: String?
    let avatar: String?
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
        self.content = content.highlight(searchStrings: ["@", "http"])
        self.date = dateString.shortDateString()
        self.inReplyTo = json["inReplyTo"] as? String
        self.avatar = json["avatar"] as? String
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

extension String {
    
    func highlight(searchStrings: [String]) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: self)
        var attributes = [[String: Any]]()

        for searchString in searchStrings {
            let searchLength = searchString.characters.count
            var range = NSRange(location: 0, length: attrString.length)

            while (range.location != NSNotFound) {
                range = (attrString.string as NSString).range(of: searchString, options: [], range: range)

                if (range.location != NSNotFound) {
                    var length = attrString.length-range.location
                    for i in range.location+searchLength..<attrString.length-1 {
                        let char = self[self.index(self.startIndex, offsetBy: i)]
                        // Detect location of next word
                        if  char ==  " " || char == "\n" {
                            length = i-range.location;
                            break
                        }
                    }
                    let matchedRange = NSRange(location: range.location, length: length)
                    if searchString == "http" {
                        let indexStart = self.index(self.startIndex, offsetBy: range.location)
                        let indexEnd = self.index(self.startIndex, offsetBy: range.location+length)
                        let urlString = self.substring(with: indexStart..<indexEnd)
                        let attr = [NSLinkAttributeName: urlString, "NSRange": matchedRange] as [String : Any]
                        attributes.append(attr)
                    }
                    else {
                        let attr = [NSForegroundColorAttributeName: UIColor.blue, "NSRange": matchedRange] as [String : Any]
                        attributes.append(attr)
                    }
                    range = NSRange(location: range.location + range.length, length: self.characters.count - (range.location + range.length))
                }
            }
        }
        for attribute in attributes {
            if attribute[NSForegroundColorAttributeName] != nil {
                attrString.addAttribute(NSForegroundColorAttributeName, value: attribute[NSForegroundColorAttributeName] as! UIColor,
                                        range: attribute["NSRange"] as! NSRange)
            }
            if attribute[NSLinkAttributeName] != nil {
                attrString.addAttribute(NSLinkAttributeName, value: attribute[NSLinkAttributeName] as! String,
                                        range: attribute["NSRange"] as! NSRange)
            }
        }
        return attrString
    }
    
    func shortDateString() -> String {
        // Convert date format from 2016-09-30T09:41:00-08:00 to 9/30/16, 9:41 PM
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

