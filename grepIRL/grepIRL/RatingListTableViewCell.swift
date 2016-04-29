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
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if (self.selected) {
            
        }
        
        print("Selected is...")
        print(self.selected)
        
    }

}
