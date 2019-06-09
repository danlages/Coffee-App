//
//  ActiveOrderVC.swift
//  To-Go
//
//  Created by Daniel Lages on 13/06/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import FirebaseFirestore

class ActiveOrder: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate {

    //MARK:Properties
    
    @IBOutlet weak var activeOrderDestinationLabel: UILabel!
    
    @IBOutlet weak var activeOrderMapView: MKMapView!
    
    @IBOutlet weak var activeOrderTimerLabel: UILabel!
    
    @IBOutlet weak var activeOrderCollectionNameLabel: UILabel!
    
    @IBOutlet weak var activeOrderTimeToCollectLabel: UILabel!
    
    @IBOutlet weak var activeOrderCollectedButton: UIButton!

    @IBOutlet weak var activeOrderTableView: UITableView!
    
    var menuItems  = [MenuItem]()  //Creates a mutable array of menu item objects - allowing for the addition of items after initilsation
    var selectedCafe = orderDetailsData.cafeName
    var nameForCollection = orderDetailsData.collectionName
    
    var orderItems = [OrderItems]()
    var orderPrices = [Float]()
    var orderRunningTotal = Float()
    
    var tableItemCells = [itemCell]()
    
    var timer = Timer()
    
    var selectedMinutes = 0
    var setTimeForCollection = ""
    let mapViewInsets = UIEdgeInsets(top: 70, left: 70, bottom: 70, right: 70)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        activeOrderMapView.delegate = self
        activeOrderMapView.showsCompass = false //Hide compus animation
        self.activeOrderDestinationLabel.text = selectedCafe
        self.activeOrderCollectionNameLabel.text = orderDetailsData.collectionName
        self.activeOrderTableView.delegate = self
        self.activeOrderTableView.dataSource = self
        self.activeOrderTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0);
        self.activeOrderTimeToCollectLabel.text = setTimeForCollection
        loadSampleMenuItems()
        buttonDesign()
        operateTimer()
       
        locationManager.delegate = self //CLLocationManager Delegate
        
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization() //Only require information when app is in the forground
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100 
        // Do any additional setup after loading the view.
    }
    
   func buttonDesign() {
        activeOrderCollectedButton.layer.cornerRadius = 5 //Rounded Button
    }
    
    private func loadSampleMenuItems() {
        
        let count = orderItems.count - 1
        var currentExtras = [String]()
        var currentSize = ""
        
        for i in 0...count{
            let itemName = orderItems[i].order[0][0]
            let itemCost = orderPrices[i]
            let extrasCount = orderItems[i].order[0].count - 1
            currentExtras = []
            
            for x in 2...extrasCount {
                currentExtras.append(orderItems[i].order[0][x])
                print(currentExtras[x-2])
            }
            currentSize = orderItems[i].order[0][1]
            
            tableItemCells.append(itemCell(open: false, item: itemName, size: currentSize, extras: currentExtras, cost: itemCost))
        }
    }
    
    
    // MARK: Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableItemCells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableItemCells[section].open == true {
            return tableItemCells[section].extras.count + 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ViewOrderTableViewCell" //Name used to recognise cell prototype - set in attributes inspector
        
        /*guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SelectItemTableViewCell else {
         
         fatalError("The Dequeued cell is not an instance of SelectItemTableViewCell.")
         }
         
         let menuItem = menuItems[indexPath.row]
         
         //Determine and set cell information
         
         cell.menuItemName.text = menuItem.name
         cell.menuItemSize.text = menuItem.size
         cell.menuItemPrice.text = String(menuItem.price)
         
         return cell*/
        
        let dataIndex = indexPath.row - 1
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ViewOrderTableViewCell else {
                fatalError("The Dequeued cell is not an instance of ViewOrderTableViewCell.")
            }
            
            cell.itemName.text = tableItemCells[indexPath.section].item
            cell.itemSize.text = tableItemCells[indexPath.section].size
            cell.itemCost.text = "£" + String(format:"%.02f", tableItemCells[indexPath.section].cost)
            return cell
        }
        else {
            /*guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SelectItemTableViewCell else {
             
             fatalError("The Dequeued cell is not an instance of SelectItemTableViewCell.")
             }
             cell.menuItemName.text = tableItemCells[indexPath.section].extras[dataIndex]*/
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellExtras") else {
                return UITableViewCell() }
            cell.textLabel?.text = tableItemCells[indexPath.section].extras[dataIndex]
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //displayActionSheet() //Display delete option to user via action sheet when cell selected
        if indexPath.row == 0 {
            if tableItemCells[indexPath.section].open == true{
                tableItemCells[indexPath.section].open = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
                tableItemCells[indexPath.section].open = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        } else {
            //something to happen when an extra is clicked?
            //remove if indexPath.row == 0 if only want to close extras when clicked and nothing else
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    let locationManager = CLLocationManager() //Define Location manager object.
    let directionRequest = MKDirections.Request()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocationCoordinate2D = manager.location!.coordinate //Determine user location
        let userLat = location.latitude
        let userLong = location.longitude
        let userLocation = CLLocation(latitude: userLat, longitude: userLong)
    
        //Convert data to readable 2D coordinate region
//        let currentLocal = userLocation.coordinate
//        let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
//        let region = MKCoordinateRegion(center: currentLocal, span: span)
    
       // activeOrderMapView.setRegion(region, animated: true) // Represent User Location on map
        self.activeOrderMapView.showsUserLocation = true
        let destinationAddress = orderDetailsData.cafeDestination
        
        let locationMarker = MKPointAnnotation() //Set Marker for Coffee Locations
        locationMarker.title = orderDetailsData.cafeName
    
        let geoCoder = CLGeocoder()
    
        geoCoder.geocodeAddressString(destinationAddress) {
            placemarks, error in
            let placemark = placemarks?.first
            let destLat = placemark?.location?.coordinate.latitude
            let destLong = placemark?.location?.coordinate.longitude
    
            locationMarker.coordinate = CLLocationCoordinate2D(latitude: destLat!, longitude: destLong!) //Set Marker for location
    
            self.activeOrderMapView.addAnnotation(locationMarker)
            
            self.directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: userLat, longitude: userLong), addressDictionary: nil))
            
            self.directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destLat!, longitude: destLong!), addressDictionary: nil))
            self.directionRequest.requestsAlternateRoutes = false
            self.directionRequest.transportType = .walking
            
            let directions = MKDirections(request: self.directionRequest)
            
            directions.calculate { [unowned self] outcome, error in //
                guard let gatheredPath = outcome, error == nil else {
                    return print ("Path not Found") }
                
                for route in gatheredPath.routes {
                    self.activeOrderMapView.addOverlay(route.polyline)
                    //self.placeOrderMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                    self.activeOrderMapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: self.mapViewInsets, animated: true) }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print ("Locations not gathered ") // If locations not gathered
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let directionalLineRenderer = MKPolylineRenderer(overlay: overlay)
        directionalLineRenderer.strokeColor = mapviewColor
        directionalLineRenderer.fillColor = UIColor.blue
        directionalLineRenderer.lineWidth = 5
        return directionalLineRenderer
    }
    
    @objc func update() { //Function called to update labels in real time
        selectedMinutes -= 1
        
        let minutes = Int(selectedMinutes) / 60 % 60
        let seconds = Int(selectedMinutes) % 60
        
        if seconds < 10 {
            activeOrderTimerLabel.text = "\(minutes):0\(seconds)"
        }
        else if seconds >= 10 {
            activeOrderTimerLabel.text = "\(minutes):\(seconds)"
        }
        
        if selectedMinutes == 0 {
        timer.invalidate()
        activeOrderTimeToCollectLabel.text = "To be Collected"
        activeOrderTimerLabel.text = "00:00"
        
        }
    }
    
    func operateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ActiveOrder.update), userInfo: nil, repeats: true)
        
    }
    
}
