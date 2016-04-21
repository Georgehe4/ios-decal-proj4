//
//  Rating.swift
//  grepIRL
//
//  Created by George He on 4/20/16.
//  Copyright © 2016 George He. All rights reserved.
//

import Foundation

class Rating {
    var rating: Int
    var relatedItem: TrackedItem!
    init (trackedItem: TrackedItem) {
        rating = 0
        relatedItem = trackedItem
    }
}
