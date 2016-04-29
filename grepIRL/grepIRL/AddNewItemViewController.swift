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
    var itemDescription : String = ""
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = self.backgroundColor
        
        // Do any additional setup after loading the view.
        navigationItem.title = "Add Item"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(AddNewItemViewController.cancelItem))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(AddNewItemViewController.saveItem))
        
        let spacing = CGFloat(10)
        let screen = UIScreen.mainScreen().bounds.size
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
        itemImageView.userInteractionEnabled = true
        
        itemImageView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(AddNewItemViewController.changeImage)))

        self.view.addSubview(itemImageView)
        
        let itemNameLx = itemImageX
        let itemNameLy = itemImageY + itemImageHeight + spacing
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
        itemNameTextField.borderStyle = UITextBorderStyle.RoundedRect
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
        itemDescripTextField.borderStyle = UITextBorderStyle.RoundedRect
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
    
    func cancelItem() {
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    func saveItem() {
        if let itemName = self.itemNameTextField.text {
            self.itemName = itemName
        }
        if let itemDescription = self.itemDescripTextField.text {
            self.itemDescription = itemDescription
        }
        
        let addedItem = TrackedItem(name: itemName, location: itemLocation, description: itemDescription, itemPhoto: itemImage, id:TrackedItem.generateItemKey())
        delegate?.saveNewItem(addedItem)
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
