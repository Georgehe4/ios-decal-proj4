//
//  AddNewItemViewController.swift
//  grepIRL
//
//  Created by Susanna Souv on 4/26/16.
//  Copyright © 2016 George He. All rights reserved.
//

import UIKit
import CoreLocation

protocol AddNewItemViewControllerDelegate {
    func saveNewItem(newItem: TrackedItem)
}

class AddNewItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var itemName : String = "NEW ITEM"
    var itemImage : UIImage!
    var itemLocation : CLLocation!
    var itemDescription : String!
    var locationName : String = "Location not yet set"
    
    var backgroundColor : UIColor = UIColor.whiteColor()
    var textColor : UIColor = UIColor.blackColor()
    var defaultBorderColor : CGColor = UIColor.grayColor().CGColor
    var defaultBorderWidth : CGFloat = CGFloat(1)
    
    // view items
    var itemImageView : UIImageView!
    var itemNameTextField : UITextField!
    var itemDescripTextField : UITextField!
    
    var delegate : AddNewItemViewControllerDelegate?
    var imagePicker = UIImagePickerController()
    
    let dropDown = DropDown()
    let tagLabel = UILabel()
    let dropDownButton = UIButton(type: UIButtonType.System)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = self.backgroundColor
        
        // Do any additional setup after loading the view.
        navigationItem.title = "Add Item"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(AddNewItemViewController.cancelItem))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(AddNewItemViewController.saveItem))
        
        let spacing = CGFloat(5)
        let screen = UIScreen.mainScreen().bounds.size
        let standardCornerRadius = CGFloat(5)
        if self.itemImage != nil {
            
        }
        else {
            self.itemImage = UIImage(named: "default")
        }
        itemImageView = UIImageView(image: itemImage)
        let itemImageHeight = CGFloat(250)
        let itemImageWidth = CGFloat(250)
        let itemImageX = screen.width/2 - itemImageWidth/2
        let itemImageY = screen.height/2 - itemImageHeight
        itemImageView.frame = CGRectMake(itemImageX, itemImageY, itemImageWidth, itemImageHeight)
        itemImageView.layer.borderWidth = CGFloat(1)
        itemImageView.layer.borderColor = defaultBorderColor
        itemImageView.layer.cornerRadius = standardCornerRadius
        itemImageView.layer.masksToBounds = true
        itemImageView.userInteractionEnabled = true
        
        itemImageView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(AddNewItemViewController.changeImage)))

        self.view.addSubview(itemImageView)
        let buttonY = itemImageY + itemImageHeight + spacing
        let buttonHeight = CGFloat(40)
        let buttonWidth = CGFloat(40)
        let tagLabelX = itemImageX + itemImageWidth - CGFloat(140)
        let tagNameLabel = UILabel(frame: CGRectMake(itemImageX, buttonY, buttonWidth, buttonHeight))
        tagNameLabel.textColor = textColor
        tagNameLabel.text = "Tags"
        self.view.addSubview(tagNameLabel)
        
        tagLabel.frame = CGRectMake(tagLabelX, buttonY, CGFloat(100), buttonHeight)
        tagLabel.text = "-"
        tagLabel.layer.borderWidth = CGFloat(1)
        tagLabel.layer.borderColor = UIColor.grayColor().CGColor
        tagLabel.textAlignment = NSTextAlignment.Center
        tagLabel.layer.cornerRadius = CGFloat(5)
        tagLabel.layer.masksToBounds = true
        self.view.addSubview(tagLabel)
        dropDownButton.setTitle("🔽", forState: UIControlState.Normal)
        dropDownButton.frame = CGRectMake(tagLabelX + tagLabel.frame.width + CGFloat(5), buttonY, buttonWidth, buttonHeight)
        //        dropDownButton.backgroundColor = UIColor.redColor()
        dropDownButton.addTarget(self, action: #selector(self.showOrDismiss(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(dropDownButton)
        
        
        dropDown.anchorView = dropDownButton
        dropDown.direction = .Any
        dropDown.bottomOffset = CGPoint(x: 0, y:dropDown.anchorView!.bounds.height)
        dropDown.dataSource = ["Food", "Sports", "Fun", "Random"]
        dropDown.width = 100
        dropDown.dismissMode = .Automatic
        dropDown.valueLabel = tagLabel
        
        let itemNameLx = itemImageX
        let itemNameLy = buttonY+buttonHeight+spacing
        let itemNameLwidth = itemImageWidth
        let itemNameLheight = CGFloat(40)
        let itemNameLabel = UILabel(frame: CGRectMake(itemNameLx, itemNameLy, itemNameLwidth, itemNameLheight))
        itemNameLabel.textColor = textColor
        itemNameLabel.text = "Item name"
        self.view.addSubview(itemNameLabel)
        
        let itemNameTFx = itemImageX
        let itemNameTFy = itemNameLy + itemNameLheight + spacing
        let itemNameTFwidth = itemNameLwidth
        let itemNameTFheight = CGFloat(40)
        self.itemNameTextField = UITextField(frame: CGRectMake(itemNameTFx, itemNameTFy, itemNameTFwidth, itemNameTFheight))
        itemNameTextField.backgroundColor = UIColor.whiteColor()
        itemNameTextField.layer.borderColor = defaultBorderColor
        itemNameTextField.layer.borderWidth = defaultBorderWidth
        itemNameTextField.layer.cornerRadius = standardCornerRadius
        itemNameTextField.layer.masksToBounds = true
        self.view.addSubview(itemNameTextField)
        
        let itemDLx = itemImageX
        let itemDLy = itemNameTFy + itemNameTFheight + spacing
        let itemDLwidth = itemImageWidth
        let itemDLheight = CGFloat(40)
        let itemDescripLabel = UILabel(frame: CGRectMake(itemDLx, itemDLy, itemDLwidth, itemDLheight))
        itemDescripLabel.textColor = textColor
        itemDescripLabel.text = "Item description"
        self.view.addSubview(itemDescripLabel)
        
        let itemDTFx = itemImageX
        let itemDTFy = itemDLy + itemDLheight + spacing
        let itemDTFwidth = itemImageWidth
        let itemDTFheight = CGFloat(40)
        self.itemDescripTextField = UITextField(frame: CGRectMake(itemDTFx, itemDTFy, itemDTFwidth, itemDTFheight))
        itemDescripTextField.backgroundColor = UIColor.whiteColor()
        itemDescripTextField.layer.borderColor = defaultBorderColor
        itemDescripTextField.layer.borderWidth = defaultBorderWidth
        itemDescripTextField.layer.cornerRadius = standardCornerRadius
        itemDescripTextField.layer.masksToBounds = true
        self.view.addSubview(itemDescripTextField)
        
        let itemLocLabelX = itemDTFx
        let itemLocLabelY = itemDTFy + itemDTFheight + spacing
        let itemLocLabelWidth = itemDLwidth
        let itemLocLabelHeight = CGFloat(40)
        let itemLocLabel = UILabel(frame: CGRectMake(itemLocLabelX, itemLocLabelY, itemLocLabelWidth, itemLocLabelHeight))
        itemLocLabel.textColor = textColor
        itemLocLabel.text = self.locationName

        if let location = self.itemLocation {
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {
                (placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    self.locationName = "Location not found"
                }
                let pm = placemarks! as [CLPlacemark]
                print(pm.count)
                if pm.count > 0 {
                    let pmFirst = pm[0]
                    self.locationName = pmFirst.name!
                    itemLocLabel.text = "Location: " + pmFirst.name!
                }
                else {
                    self.locationName = "Location not found"
                }
            })
        }
        
        self.view.addSubview(itemLocLabel)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showOrDismiss(sender: AnyObject) {
        if dropDown.hidden {
            dropDown.show()
        } else {
            if let selectedItemString = dropDown.selectedItem {
                tagLabel.text = selectedItemString
            }
            dropDown.hide()
        }
    }

    
    func cancelItem() {
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    func saveItem() {
        if (self.itemNameTextField.text == "") {
            let noNameAlertController = UIAlertController(
                title: "Item needs a name!", message: "Please enter a name for the new item", preferredStyle: .Alert)
            noNameAlertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            self.presentViewController(noNameAlertController, animated: true, completion: nil)
        }
        else if let itemName = self.itemNameTextField.text {
            self.itemName = itemName
            if self.itemDescripTextField.text != "" {
                self.itemDescription = self.itemDescripTextField.text
            }
            else {
                self.itemDescription = "No description"
            }
            if itemLocation == nil {
                let alert = UIAlertController(title: "No Location Provided", message: "Please make sure location services is turned on", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
                if let tag = dropDown.selectedItem {
                    let addedItem = TrackedItem(name: self.itemName, location: itemLocation, description: self.itemDescription, itemPhoto: itemImage, id:TrackedItem.generateItemKey(), tags: [tag])
                    addedItem.locationString = self.locationName
                    delegate?.saveNewItem(addedItem)
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else {
                    let invalidRatingAlertController = UIAlertController(title: "Invalid tag", message: "Please select a tag", preferredStyle: .Alert)
                    invalidRatingAlertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                    self.presentViewController(invalidRatingAlertController, animated: true, completion: nil)

                }
                
            }
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
    func changeImage() {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        itemImageView.image = image
        self.itemImage = image
        
    }
    

}
