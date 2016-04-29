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
    var isExpanded = false // default
    
    var cellTrackedItem : TrackedItem! = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        // Configure the view for the selected state
        isExpanded = selected
        if let currItem = self.cellTrackedItem {
            if (isExpandable) {
                if (isExpanded) {
                    print("UNEXPAND")
                    
                }
                else {
                    print("EXPAND")
                }
                textLabel?.text = currItem.name
                
                print(selected)
                super.setSelected(selected, animated: animated)
            }
            else {
                
            }
        }
        
        
    }

}
