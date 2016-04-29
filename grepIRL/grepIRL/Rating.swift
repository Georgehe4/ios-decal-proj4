//
//  Rating.swift
//  grepIRL
//
//  Created by George He on 4/20/16.
//  Copyright © 2016 George He. All rights reserved.
//

import UIKit

class Rating: NSObject, NSCoding{
    var rating: Int
    
    var relatedItemID: Int
    
    var ratingDescription: String!
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("ratings")
    
    init (trackedItem: Int, rating: Int, description: String!) {
        self.rating = rating
        self.relatedItemID = trackedItem
        self.ratingDescription = description
    }
    
    struct PropertyKey {
        static let ratingKey = "rating"
        static let itemKey = "item"
        static let descriptionKey = "description"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(rating, forKey: PropertyKey.ratingKey)
        aCoder.encodeObject(relatedItemID, forKey: PropertyKey.itemKey)
        aCoder.encodeObject(ratingDescription, forKey: PropertyKey.descriptionKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let rating = aDecoder.decodeIntegerForKey(PropertyKey.ratingKey)
        
        let itemID = aDecoder.decodeObjectForKey(PropertyKey.itemKey) as! Int
        
        let description = aDecoder.decodeObjectForKey(PropertyKey.descriptionKey) as! String
        
        // Must call designated initializer.
        self.init(trackedItem: itemID, rating: rating, description:description)
    }
}
