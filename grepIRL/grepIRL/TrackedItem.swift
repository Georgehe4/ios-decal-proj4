//
//  TrackedItem.swift
//  grepIRL
//
//  Created by George He on 4/20/16.
//  Copyright © 2016 George He. All rights reserved.
//

import UIKit
import CoreLocation

class TrackedItem {
    var location : CLLocation!
    var description : String!
    var name: String!
    // tags will be implemented later
    var itemPhoto : UIImage?

    init(name: String, location: CLLocation, description: String, itemPhoto: UIImage?) {
        self.location = location
        self.description = description
        self.itemPhoto = itemPhoto
        self.name = name
    }
    
}
