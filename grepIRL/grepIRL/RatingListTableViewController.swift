//
//  RatingListTableViewController.swift
//  grepIRL
//
//  Created by George He on 4/20/16.
//  Copyright © 2016 George He. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RatingListTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate {
    //var trackedItems: [TrackedItem]!
    let locationManager = CLLocationManager()
    var requiresMapUpdate = false
    var tableView: UITableView!  =   UITableView()
    
    var mapView: MKMapView! = MKMapView()
    var selectedIndex = 0
    
    let ownObject: TrackedItem = TrackedItem(name: "ME",location: CLLocation(latitude: CLLocationDegrees("0")!, longitude: CLLocationDegrees("0")!), description: "SOMETHING", itemPhoto: UIImage(named:"Placeholder"))
    
    var items: [TrackedItem] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requiresMapUpdate = true
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        if (items.isEmpty) {
            items.append(ownObject)
        }
        
        let screen = UIScreen.mainScreen().bounds.size
        
        navigationItem.title = "GREP_IRL"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add new item", style: .Plain, target: self, action: #selector(RatingListTableViewController.addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Map", style: .Plain, target: self, action: #selector(RatingListTableViewController.mapViewScreen))
        
        mapView.mapType = .Standard
        mapView.showsUserLocation = true
        let ratio:CGFloat = 2/5
        mapView.frame = CGRectMake(0, 0, screen.width, screen.height*ratio);
        mapView.delegate = self
        view.addSubview(mapView)
        
        tableView.frame         =   CGRectMake(0, screen.height*ratio, screen.width, screen.height*(1-ratio));
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.sectionHeaderHeight = 30
        
        tableView.registerClass(TableHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.registerClass(RatingListTableViewCell.self, forCellReuseIdentifier: "cell")

        
        self.view.addSubview(tableView)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations.last!
        self.ownObject.location = location
        if (self.selectedIndex == 0 && self.requiresMapUpdate) {
            self.requiresMapUpdate = false
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterViewWithIdentifier("header")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:RatingListTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as! RatingListTableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row].name
        self.selectedIndex = indexPath.row
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.frame = CGRectMake(0, 0, 3200, 500)
        navigationItem.title = "GREP_IRL"
        
        
        tableView.registerClass(RatingListTableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.registerClass(TableHeader.self, forHeaderFooterViewReuseIdentifier: "headerId")
        
        tableView.sectionHeaderHeight = 50
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add new item", style: .Plain, target: self, action: "addItem")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Map", style: .Plain, target: self, action: "mapView")
        
        tableView.frame = CGRectMake(200, 200, 100, 100)
    }*/
    
    
    func addItem() {
        // goes to addNewItemView
        let addItemViewController = AddNewItemViewController()
        print(mapView.userLocation.location)
        addItemViewController.itemLocation = mapView.userLocation.location
//        print(addItemViewController.itemLocation != nil)
//        self.presentViewController(addItemViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(addItemViewController, animated: true)
    }
    
    
    func mapViewScreen() {
        
    }
    

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
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

class TableHeader: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Items Near You"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFontOfSize(14)
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
}
