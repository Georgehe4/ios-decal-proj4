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

class RatingListTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate, AddNewItemViewControllerDelegate, AddRatingViewControllerDelegate, UISearchResultsUpdating {
    //var trackedItems: [TrackedItem]!
    let locationManager = CLLocationManager()
    var requiresMapUpdate = false
    var tableView: UITableView!  =   UITableView()
    
    var mapView: MKMapView! = MKMapView()
    var selectedIndex = 0
    
    var ratings: [Int: [Rating]] = [:] //Map from objectID to rating
    let allowedTags = ["All", "Food", "Sports", "Fun", "Random"]
    
    let seedItem: TrackedItem = TrackedItem(name: "ME",location: CLLocation(latitude: CLLocationDegrees("40.730872")!, longitude: CLLocationDegrees("-74.003066")!), description: "SOMETHING", itemPhoto: UIImage(named:"default"), id:TrackedItem.generateItemKey())
    var seedItemRatings : [Rating]? { return [Rating(trackedItem: seedItem.itemID, rating: 5, description: "Good shit"), Rating(trackedItem: seedItem.itemID, rating: 5, description: "Good shit"), Rating(trackedItem: seedItem.itemID, rating: 5, description: "Good shit"), Rating(trackedItem: seedItem.itemID, rating: 5, description: "Good shit"), Rating(trackedItem: seedItem.itemID, rating: 5, description: "Good shit"), Rating(trackedItem: seedItem.itemID, rating: 5, description: "Good shit"), Rating(trackedItem: seedItem.itemID, rating: 5, description: "Good shit")] }
    
    
    var items: [TrackedItem] = []
    var filterItems = [TrackedItem]()
    
    var selectedRowIndex = -1
    var selectedRowExists = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
//        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = allowedTags
        
        
        self.requiresMapUpdate = true
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        items = loadItems()!
        
        print(items)
        if (items.isEmpty) {
            items.append(seedItem)
            print("We have items")
            if let _ = seedItemRatings {
                print("Ratings exist")
                ratings[seedItem.itemID] = seedItemRatings
            }
        }
        
        let screen = UIScreen.mainScreen().bounds.size
        
        navigationItem.title = "GREP_IRL"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add new item", style: .Plain, target: self, action: #selector(RatingListTableViewController.addItem))
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Map", style: .Plain, target: self, action: #selector(RatingListTableViewController.mapViewScreen))
        
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
//        self.seedItem.location = location
        if (self.selectedIndex == 0 && self.requiresMapUpdate) {
            self.requiresMapUpdate = false
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            ratings.removeValueForKey(items[indexPath.row].itemID)
            saveRatings()
            items.removeAtIndex(indexPath.row)
            saveItems()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            addItem()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filterItems.count
        }
        return self.items.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterViewWithIdentifier("header")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {        
        var cell:RatingListTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as! RatingListTableViewCell
        var cellItem = self.items[indexPath.row]
        if searchController.active && searchController.searchBar.text != "" {
            cellItem = filterItems[indexPath.row]
        } else {
            cellItem = items[indexPath.row]
        }
        for (id, rates) in ratings {
            if (cellItem.itemID == id) {
                cellItem.ratings = rates
            }
        }
        cell = RatingListTableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        cell.trackedItem = cellItem
        cell.textLabel?.text = cellItem.name
        cell.detailTextLabel?.text = ""
        let imgviewFrame = CGRectMake(cell.frame.minX + 10, cell.frame.minY + 10, cell.frame.width - 20, cell.frame.height - 20)
        cell.imageView!.image = cellItem.itemPhoto
        cell.imageView?.frame = imgviewFrame
        
        let screen = UIScreen.mainScreen().bounds.size
        let button : UIButton = UIButton(type: UIButtonType.System)
        let buttonWidth = CGFloat(40)
        button.frame = CGRectMake(screen.width - buttonWidth - 10, 10, buttonWidth, 20)
//        button.backgroundColor = UIColor.cyanColor()
        button.tag = indexPath.row
        button.addTarget(self, action: #selector(RatingListTableViewController.addRating(_:)), forControlEvents: .TouchUpInside)
        button.setTitle("Rate", forState: UIControlState.Normal)
        cell.addSubview(button)
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
//        let cell:RatingListTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RatingListTableViewCell
        var needToUpdateRows : [NSIndexPath] = [NSIndexPath]()
        if (selectedRowIndex == -1 && !selectedRowExists) {
            selectedRowIndex = indexPath.row
            self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.selectedRowIndex, inSection: 0))?.setSelected(true, animated: true)
            selectedRowExists = true
        }
        else  if (selectedRowIndex != indexPath.row && selectedRowExists) {
            self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.selectedRowIndex, inSection: 0))?.setSelected(false, animated: true)
            needToUpdateRows.append(NSIndexPath(forRow: self.selectedRowIndex, inSection: 0))
            self.selectedRowIndex = indexPath.row
            self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.selectedRowIndex, inSection: 0))?.setSelected(true, animated: true)
        }
        else if (selectedRowIndex == indexPath.row && selectedRowExists) {
            self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.selectedRowIndex, inSection: 0))?.setSelected(false, animated: true)
            selectedRowIndex = -1
            selectedRowExists = false
        }
        
        tableView.reloadRowsAtIndexPaths(needToUpdateRows, withRowAnimation: UITableViewRowAnimation.Automatic)
        mapViewScreen()
        
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
        let addItemViewController = AddNewItemViewController()
        addItemViewController.itemLocation = mapView.userLocation.location
        addItemViewController.delegate = self
        self.navigationController?.pushViewController(addItemViewController, animated: true)
    }
    
    func addRating(sender: UIButton!) {
        let addRatingViewController = AddRatingViewController()
        let id = items[sender.tag].itemID
        let name = items[sender.tag].name!
        addRatingViewController.relatedItemID = id
        addRatingViewController.itemName = name
        addRatingViewController.delegate = self
        self.navigationController?.pushViewController(addRatingViewController, animated: true)

    }
    
    func mapViewScreen() {
        if (selectedRowExists) {
            if !mapView.annotations.isEmpty {
                mapView.removeAnnotations(mapView.annotations)
            }
            let currItemPin = MKPointAnnotation()
            currItemPin.coordinate = items[selectedRowIndex].location.coordinate
            let center = currItemPin.coordinate
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
            mapView.addAnnotation(currItemPin)
        }
        else {
            if !mapView.annotations.isEmpty {
                mapView.removeAnnotations(mapView.annotations)
            }
            let center = mapView.userLocation.coordinate
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
        }
        locationManager.startUpdatingLocation()
    }
    

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func saveNewItem(newItem: TrackedItem) {
        self.items.append(newItem)
        self.tableView.reloadData()
        saveItems()
    }
    
    func saveNewRating(newRating: Rating) {
        if (ratings[newRating.relatedItemID]) != nil {
            self.ratings[newRating.relatedItemID]!.append(newRating)
        }
        else {
            self.ratings[newRating.relatedItemID] = [newRating]
        }
        self.tableView.reloadData()
        saveRatings()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func saveItems() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(items, toFile: TrackedItem.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save items...")
        }
    }
    
    func loadItems() -> [TrackedItem]? {
        if let loadedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(TrackedItem.ArchiveURL.path!) as? [TrackedItem] {
            return loadedItems
        }
        return []
    }

    func saveRatings() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ratings, toFile: Rating.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save ratings...")
        }
    }
    
    func loadRatings() -> [Int: [Rating]]? {
        if let loadedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(Rating.ArchiveURL.path!) as? [Int: [Rating]] {
            return loadedItems
        }
        return [:]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == selectedRowIndex {
            if (items[selectedRowIndex].ratings != nil && items[selectedRowIndex].ratings.count > 5) {
                let ratingCount = items[selectedRowIndex].ratings.count
                return CGFloat(140 + ((ratingCount - 5) * 20))
            }
            else {
                return 140
            }
            
        }
        return 44
    }
    
    func updateSearchResultsForSearchController(_: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        searchController.searchBar.sizeToFit()
        filterItems = items.filter { item in
            let categoryMatch = (scope == "All") || (item.tags!.contains(scope))
            return categoryMatch && item.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }


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
