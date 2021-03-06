//
//  TrackedItem.swift
//  grepIRL
//
//  Created by George He on 4/20/16.
//  Copyright © 2016 George He. All rights reserved.
//

import UIKit
import CoreLocation

class TrackedItem: NSObject, NSCoding {
    var location : CLLocation!
    var itemDescription : String!
    var name: String!
    // tags will be implemented later
    var itemPhoto : UIImage?
    var itemID: Int
    var locationString = ""
    
    var tags:[String]? = [String]()
    var ratings : [Rating]!

    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("trackedItems")
    
    init(name: String, location: CLLocation, description: String, itemPhoto: UIImage?, id: Int, tags: [String]?) {
        self.location = location
        self.itemDescription = description
        self.itemPhoto = itemPhoto
        self.name = name
        self.itemID = id
        if tags != nil {
            self.tags = tags!
        }
    }
    
    init(name: String, location: CLLocation, description: String, itemPhoto: UIImage?, id: Int) {
        self.location = location
        self.itemDescription = description
        self.itemPhoto = itemPhoto
        self.name = name
        self.itemID = id
    }
    
    static func generateItemKey() -> Int{
        return Int(arc4random())
    }
    
    // MARK: NSCoding
    
    struct PropertyKey {
        static let locationKey = "location"
        static let descriptionKey = "description"
        static let nameKey = "name"
        static let photoKey = "photo"
        static let idKey = "id"
        static let tagKey = "tags"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(itemPhoto, forKey: PropertyKey.photoKey)
        aCoder.encodeObject(location, forKey: PropertyKey.locationKey)
        aCoder.encodeObject(tags, forKey: PropertyKey.tagKey)
        aCoder.encodeObject(itemDescription, forKey: PropertyKey.descriptionKey)
        aCoder.encodeInteger(itemID, forKey: PropertyKey.idKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        
        let location = aDecoder.decodeObjectForKey(PropertyKey.locationKey) as! CLLocation

        let description = aDecoder.decodeObjectForKey(PropertyKey.descriptionKey) as! String
        
        let id = aDecoder.decodeIntegerForKey(PropertyKey.idKey)
        
        let tags = aDecoder.decodeObjectForKey(PropertyKey.tagKey) as? [String]
        
        // Must call designated initializer.
        self.init(name: name, location:location, description:description, itemPhoto: photo, id:id, tags:tags)
    }
}
