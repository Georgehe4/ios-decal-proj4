//
//  AddRatingViewController.swift
//  grepIRL
//
//  Created by George He on 4/20/16.
//  Copyright © 2016 George He. All rights reserved.
//

import UIKit
import CoreLocation

protocol AddRatingViewControllerDelegate {
    func saveNewRating(newRating: Rating)
}

class AddRatingViewController: UIViewController {
    
    var itemName : String!
    var relatedItemID: Int = 0
    var ratingComment : String = ""
    
    var backgroundColor : UIColor = UIColor.whiteColor()
    var textColor : UIColor = UIColor.blackColor()
    var defaultBorderColor : CGColor = UIColor.grayColor().CGColor
    var defaultBorderWidth : CGFloat = CGFloat(1)
    
    // view items
    var itemNameTextField : UITextField!
    var itemDescripTextField : UITextField!
    
    var delegate : AddRatingViewControllerDelegate?
    var imagePicker = UIImagePickerController()
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropDown.anchorView = view
        dropDown.bottomOffset = CGPoint(x: 0, y:dropDown.anchorView!.bounds.height)
        dropDown.dataSource = ["1", "2", "3", "4", "5"]
        
        
        self.view.backgroundColor = self.backgroundColor
        // Do any additional setup after loading the view.
        navigationItem.title = "Add A Comment"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(AddRatingViewController.cancelItem))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(AddRatingViewController.saveItem))
        
        let spacing = CGFloat(10)
        let screen = UIScreen.mainScreen().bounds.size
        
        let itemNamewidth = CGFloat(200)
        let itemNameLx = screen.width/2 - 100
        let itemNameLy = screen.height/2 - 100
        let itemNameLheight = CGFloat(40)
        let itemNameLabel = UILabel(frame: CGRectMake(itemNameLx, itemNameLy, itemNamewidth, itemNameLheight))
        itemNameLabel.textColor = textColor
        itemNameLabel.text = "Item name"
        self.view.addSubview(itemNameLabel)
        
        let itemDLx = itemNameLx
        let itemDLy = itemNameLy + itemNameLheight + spacing
        let itemDLwidth = CGFloat(200)
        let itemDLheight = CGFloat(40)
        let itemDescripLabel = UILabel(frame: CGRectMake(itemDLx, itemDLy, itemDLwidth, itemDLheight))
        itemDescripLabel.textColor = textColor
        itemDescripLabel.text = "Item description"
        self.view.addSubview(itemDescripLabel)
        
        itemDescripTextField.backgroundColor = UIColor.whiteColor()
        itemDescripTextField.layer.borderColor = defaultBorderColor
        itemDescripTextField.layer.borderWidth = defaultBorderWidth
        itemDescripTextField.borderStyle = UITextBorderStyle.RoundedRect
        self.view.addSubview(itemDescripTextField)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelItem() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveItem() {
        let item = Int(dropDown.selectedItem!)
        let addedRating = Rating(trackedItem: relatedItemID, rating: item!, description: "")
        delegate?.saveNewRating(addedRating)
        self.navigationController?.popViewControllerAnimated(true)
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
