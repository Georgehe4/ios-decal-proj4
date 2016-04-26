//
//  AddNewItemViewController.swift
//  grepIRL
//
//  Created by Susanna Souv on 4/26/16.
//  Copyright © 2016 George He. All rights reserved.
//

import UIKit
import CoreLocation

class AddNewItemViewController: UIViewController {
    
    var itemImage : UIImage!
    var itemLocation : CLLocation!
    var itemDescription : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let spacing = CGFloat(10)
        let screen = UIScreen.mainScreen().bounds.size
        var itemImageView : UIImageView!
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
        self.view.addSubview(itemImageView)
        
        
        let itemDLx = itemImageX
        let itemDLy = itemImageY + itemImageHeight + spacing
        let itemDLwidth = itemImageWidth
        let itemDLheight = CGFloat(40)
        let itemDescripLabel = UILabel(frame: CGRectMake(itemDLx, itemDLy, itemDLwidth, itemDLheight))
        itemDescripLabel.textColor = UIColor.whiteColor()
        itemDescripLabel.text = "Item description"
        self.view.addSubview(itemDescripLabel)
        
        let itemDTFx = itemImageX
        let itemDTFy = itemImageY + itemImageHeight + itemDLheight + spacing
        let itemDTFwidth = itemImageWidth
        let itemDTFheight = CGFloat(40)
        let itemDescripTextfield = UITextField(frame: CGRectMake(itemDTFx, itemDTFy, itemDTFwidth, itemDTFheight))
        itemDescripTextfield.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(itemDescripTextfield)
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
