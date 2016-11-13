//
//  TimelineViewCell.swift
//  OpenTweet
//
//  Created by Stephen Ling on 11/8/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

class TimelineViewCell: UITableViewCell {
    
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var avatar: UILabel!
    @IBOutlet weak var tweetImage: UIImageView!
    
}
