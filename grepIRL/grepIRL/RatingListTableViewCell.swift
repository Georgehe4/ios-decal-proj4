//
//  RatingListTableViewCell.swift
//  grepIRL
//
//  Created by George He on 4/20/16.
//  Copyright © 2016 George He. All rights reserved.
//

import UIKit

class RatingListTableViewCell: UITableViewCell {
    
    // what information do we want to display?
    let isExpandable = true

    
    var cellTrackedItem : TrackedItem! = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        if (selected) {
            super.setSelected(true, animated: true)
        }
        else {
            super.setSelected(false, animated: true)
        }
//        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        print("Selected is...")
        print(selected)
        
    }

}
