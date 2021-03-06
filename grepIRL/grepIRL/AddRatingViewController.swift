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
    let ratingLabel = UILabel()
    let dropDownButton = UIButton(type: UIButtonType.System)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = self.backgroundColor
        // Do any additional setup after loading the view.
        navigationItem.title = "Rate"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(AddRatingViewController.cancelItem))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(AddRatingViewController.saveItem))
        
        
        let spacing = CGFloat(10)
        let screen = UIScreen.mainScreen().bounds.size
        
        let itemNamewidth = CGFloat(200)
        let itemNameLx = screen.width/2 - 100
        let itemNameLy = CGFloat(100)
        let itemNameLheight = CGFloat(40)
        let itemNameLabel = UILabel(frame: CGRectMake(itemNameLx, itemNameLy, itemNamewidth, itemNameLheight))
        itemNameLabel.textColor = textColor
        itemNameLabel.text = itemName
        self.view.addSubview(itemNameLabel)
        
        
        let buttonY = itemNameLy + spacing + itemNameLheight
        let buttonHeight = CGFloat(40)
        let buttonWidth = CGFloat(40)
        
        ratingLabel.frame = CGRectMake(itemNameLx, itemNameLy + itemNameLheight+spacing, CGFloat(40), buttonHeight)
        ratingLabel.text = "-"
        ratingLabel.layer.borderWidth = CGFloat(1)
        ratingLabel.layer.borderColor = UIColor.grayColor().CGColor
        ratingLabel.textAlignment = NSTextAlignment.Center
        ratingLabel.layer.cornerRadius = CGFloat(5)
        ratingLabel.layer.masksToBounds = true
        self.view.addSubview(ratingLabel)
        dropDownButton.setTitle("🔽", forState: UIControlState.Normal)
        dropDownButton.frame = CGRectMake(itemNameLx + ratingLabel.frame.width + CGFloat(5), itemNameLy + itemNameLheight+spacing, buttonWidth, buttonHeight)
//        dropDownButton.backgroundColor = UIColor.redColor()
        dropDownButton.addTarget(self, action: #selector(self.showOrDismiss(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(dropDownButton)

        
        dropDown.anchorView = dropDownButton
        dropDown.direction = .Any
        dropDown.bottomOffset = CGPoint(x: 0, y:dropDown.anchorView!.bounds.height)
        dropDown.dataSource = ["1", "2", "3", "4", "5"]
        dropDown.width = 100
        dropDown.dismissMode = .Automatic
        dropDown.valueLabel = ratingLabel
        
        let itemDLx = itemNameLx
        let itemDLy = buttonY + buttonHeight + spacing
        let itemDLwidth = CGFloat(200)
        let itemDLheight = CGFloat(40)
        let itemDescripLabel = UILabel(frame: CGRectMake(itemDLx, itemDLy, itemDLwidth, itemDLheight))
        itemDescripLabel.textColor = textColor
        itemDescripLabel.text = "Comments"
        self.view.addSubview(itemDescripLabel)
        
        let itemDTFx = itemNameLx
        let itemDTFy = itemDLy + itemDLheight + 10
        let itemDTFwidth = CGFloat(200)
        let itemDTFheight = CGFloat(40)
        
        self.itemDescripTextField = UITextField(frame: CGRectMake(itemDTFx, itemDTFy, itemDTFwidth, itemDTFheight))
        itemDescripTextField.backgroundColor = UIColor.whiteColor()
        itemDescripTextField.layer.borderColor = UIColor.grayColor().CGColor
        itemDescripTextField.layer.borderWidth = CGFloat(1)
        itemDescripTextField.layer.cornerRadius = CGFloat(5)
        itemDescripTextField.layer.masksToBounds = true
        self.view.addSubview(itemDescripTextField)
    }
    
    func showOrDismiss(sender: AnyObject) {
        if dropDown.hidden {
            dropDown.show()
        } else {
            if let selectedItemString = dropDown.selectedItem {
                ratingLabel.text = selectedItemString
            }
            dropDown.hide()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelItem() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveItem() {
        if let ratingValue = dropDown.selectedItem {
            let item = Int(ratingValue)
            var ratingDescrip = self.itemDescripTextField.text
            if (ratingDescrip == "") {
                ratingDescrip = "No comment"
            }
            
            let addedRating = Rating(trackedItem: relatedItemID, rating: item!, description: ratingDescrip)
            delegate?.saveNewRating(addedRating)
            self.navigationController?.popViewControllerAnimated(true)
        }
        else {
            let invalidRatingAlertController = UIAlertController(title: "Invalid rating", message: "Please select a rating", preferredStyle: .Alert)
            invalidRatingAlertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            self.presentViewController(invalidRatingAlertController, animated: true, completion: nil)
        }
        
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
