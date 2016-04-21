//
//  Rating.swift
//  grepIRL
//
//  Created by George He on 4/20/16.
//  Copyright © 2016 George He. All rights reserved.
//

import UIKit

class Rating {
    var rating: Int
    
    var relatedItemID: Int
    
    var description: String!
    
    var picture: UIImage?
    
    init (trackedItem: Int, rating: Int, description: String!, picture: UIImage?) {
        self.rating = rating
        self.relatedItemID = trackedItem
        self.description = description
        self.picture = picture
    }
}
