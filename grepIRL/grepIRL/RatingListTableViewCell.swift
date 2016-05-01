//
//  RatingListTableViewCell.swift
//  grepIRL
//
//  Created by George He on 4/20/16.
//  Copyright © 2016 George He. All rights reserved.
//

import UIKit

class RatingListTableViewCell: UITableViewCell {
    
    var trackedItem : TrackedItem! = nil

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if (selected) {
            detailTextLabel?.text = trackedItem.itemDescription
            if let ratings = trackedItem.ratings  {
                detailTextLabel?.numberOfLines = (detailTextLabel?.numberOfLines)! + 1
                detailTextLabel!.text?.appendContentsOf("\n Ratings: ")
                for rating in ratings {
                    detailTextLabel?.numberOfLines = (detailTextLabel?.numberOfLines)! + 1
                    detailTextLabel!.text?.appendContentsOf("\n " + String(rating.rating) + ": " + rating.ratingDescription)
                }
                
            }
            
            
        }
        else {
            detailTextLabel?.text = ""
        }
        textLabel?.text = trackedItem.name
    }

}
