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
    
    var timer = Timer()
    
    var selectedMinutes = 0
    var setTimeForCollection = ""
    let mapViewInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeOrderMapView.delegate = self
        self.activeOrderDestinationLabel.text = selectedCafe
        self.activeOrderCollectionNameLabel.text = orderDetailsData.collectionName
        self.activeOrderTableView.delegate = self
        self.activeOrderTableView.dataSource = self
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
        
        //let db = Firestore.firestore()
        
        /*guard let menuItem1 = MenuItem(name: "Coffee", size: "Small", price: "£2.00") else{
         
         fatalError("Unable to create the training ground menu item") //Error message
         }
         
         menuItems += [menuItem1]*/
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SelectItemTableViewCell" //Name used to recognise cell prototype - set in attributes inspector
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SelectItemTableViewCell else {
            
            fatalError("The Dequeued cell is not an instance of SelectItemTableViewCell.")
        }
        
        //Determine and set cell information

        return cell
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
        let currentLocal = userLocation.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        let region = MKCoordinateRegion(center: currentLocal, span: span)
    
        activeOrderMapView.setRegion(region, animated: true) // Represent User Location on map
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
                    self.activeOrderMapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: self.mapViewInsets, animated: true)
                
                }
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
