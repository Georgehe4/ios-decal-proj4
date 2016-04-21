//
//  RatingListTableViewController.swift
//  grepIRL
//
//  Created by George He on 4/20/16.
//  Copyright © 2016 George He. All rights reserved.
//

import UIKit

class RatingListTableViewController: UITableViewController {
    
    //var trackedItems: [TrackedItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "GREP_IRL"
        
        tableView.registerClass(RatingListTableViewCell.self, forCellReuseIdentifier: "cellId")
        
        tableView.sectionHeaderHeight = 49
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
