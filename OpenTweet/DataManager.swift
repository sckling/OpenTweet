//
//  DataManager.swift
//  OpenTweet
//
//  Created by Stephen Ling on 11/8/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import Foundation

class DataManager {
    class func loadDataFromFile(completion: @escaping ((_ data: Data) -> Void)) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let filePath = Bundle.main.path(forResource: "timeline", ofType:"json")
            let data = try! NSData(contentsOfFile:filePath!, options: NSData.ReadingOptions.uncached)
            completion(data as Data)
        }
    }
}
