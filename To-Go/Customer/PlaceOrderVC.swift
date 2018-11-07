//
//  PlaceOrderVC.swift
//  To-Go
//
//  Created by Daniel Lages on 07/06/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

//MARK: TableViewCells


class PlaceOrderVC: UIViewController, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate  {

    //MARK:Properties
   
    
    
    @IBOutlet weak var locationNameLabel: UILabel!
    
    @IBOutlet weak var nameForCollectionTextField: UITextField!
    
    @IBOutlet weak var selectPickupTimeTextField: UITextField!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var placeOrderButtonOutlet: UIButton!
    
    @IBAction func placeOrderButtonAction(_ sender: Any) {
        validateEntry()
        
    }
    @IBOutlet weak var placeOrderScrollView: UIScrollView!
    
    @IBOutlet weak var placeOrderMapView: MKMapView!
   
    
    
    var timePicker = UIPickerView()  //Picker for selecting time for collection
    // let timePickerData = [String](arrayLiteral: "varrinutes", "15 Minutes", "20 Minutes", "25 Minutes") //List of Time Options For collection
    let timesAvaliable = [10, 15, 20, 25]
    var mins = 0
    let mapViewInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeOrderMapView.delegate = self
        locationManager.delegate = self //CLLocationManager Delegate
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization() //Only require information when app is in the forground
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
        
        timePicker.delegate = self
        timePicker.dataSource = self
        timePicker.backgroundColor = accentColor //Set Colour of Picker View
        self.nameForCollectionTextField.delegate = self
        locationNameLabel.text = orderDetailsData.cafeName
        self.selectPickupTimeTextField.delegate = self
        selectPickupTimeTextField.inputView = timePicker
        errorMessageLabel.text = "" //Do not display error upon load
        
       
       //Only update distance information when user has moved given number of meters from previous update to improve efficiency
       
        //Notify when keyboard/picker is present
        NotificationCenter.default.addObserver(self, selector: #selector(self.userInputPresent), name: UIApplication.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.userInputEnded), name: UIApplication.keyboardDidHideNotification, object: nil)
        
        navbar();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ActiveOrder
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let dataData = formatter.string(from: Date() + TimeInterval(mins))
    
        destination.setTimeForCollection = "Collect at: " + dataData
        destination.selectedMinutes = mins
        orderDetailsData.collectionName = nameForCollectionTextField.text!
    }
    
    func navbar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        placeOrderButtonOutlet.layer.cornerRadius = 5 //Button Design
    }

    //MARK: Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return
//    }

    //Picker Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timesAvaliable.count //Set to number of time options
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        mins = timesAvaliable[row] * 60
        return String(timesAvaliable[row]) + " Minutes"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent: Int) {
        selectPickupTimeTextField.text = String(timesAvaliable[row]) + " Minutes "
        
        dismissKeyboard()
    }
    
    //MARK: CollectionNameTextField
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorMessageLabel.text = ""
    }
    
    func textFieldShouldReturn(_ nameForCollectionTextField: UITextField) -> Bool {
        dismissKeyboard() //Exit keyboard when promted (Done Button)
        return true
    }
    
    //MARK: Place Order Code
    
    func validateEntry() {
        //Validate Text Fields
        let collectionName = nameForCollectionTextField.text
        let collectionTimeText = selectPickupTimeTextField.text
        
        if collectionName == "" && collectionTimeText == ""
        {
            errorMessageLabel.text = "Please enter collection name and time"
        }
        else if collectionTimeText == ""
        {
            errorMessageLabel.text = "Please enter a collection time"
        }
        else if collectionName == ""
        {
            errorMessageLabel.text = "Please enter a collection name"
            //Next Step
        }
        else {
            performSegue(withIdentifier: "makeOrderActive", sender: self)
            
        }
    }
    
    let locationManager = CLLocationManager() //Define Location manager object.
    let directionRequest = MKDirections.Request()

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Delegate function allows us to handle loaction information
        
        let location:CLLocationCoordinate2D = manager.location!.coordinate //Determine user location
        let userLat = location.latitude
        let userLong = location.longitude
        let userLocation = CLLocation(latitude: userLat, longitude: userLong)
            
            //Convert data to readable 2D coordinate region
      
        let currentLocal = userLocation.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09)
        let region = MKCoordinateRegion(center: currentLocal, span: span)
            
        placeOrderMapView.setRegion(region, animated: true) // Represent User Location on map
        self.placeOrderMapView.showsUserLocation = true
        
        let destinationAddress = orderDetailsData.cafeDestination
        
        let locationMarker = MKPointAnnotation() //Set Marker for Coffee Locations
        locationMarker.title = orderDetailsData.cafeName
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(destinationAddress) {
            placemarks, error in
            let placemark = placemarks?.first
            
            let destLat = placemark?.location?.coordinate.latitude
            let destLong = placemark?.location?.coordinate.longitude

            locationMarker.coordinate = CLLocationCoordinate2D(latitude: destLat!, longitude: destLong!) //Set Marker for Cafe location
            
            self.placeOrderMapView.addAnnotation(locationMarker)
            
            self.directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: userLat, longitude: userLong), addressDictionary: nil))

            self.directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destLat!, longitude: destLong!), addressDictionary: nil))
            
            self.directionRequest.requestsAlternateRoutes = false
            self.directionRequest.transportType = .walking
            
            let directions = MKDirections(request: self.directionRequest)
            
            directions.calculate { [unowned self] outcome, error in //
            guard let gatheredPath = outcome, error == nil else {
               return print ("Path not Found") }
            
            for route in gatheredPath.routes {
                    self.placeOrderMapView.addOverlay(route.polyline)
                    //self.placeOrderMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                    self.placeOrderMapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: self.mapViewInsets, animated: true)
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
    
    //MARK: Scroll View Positioning
    
    @objc func userInputPresent(notification: NSNotification) {
        var currentStatus = notification.userInfo
        let insetSize = currentStatus![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect //set inset size to size of keyboard/picker
        placeOrderScrollView.contentInset = UIEdgeInsets(top: 0.0, left: 00, bottom: insetSize.height, right: 0.0) //Move Scroll view up to desired inset size
        placeOrderScrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 00, bottom: insetSize.height, right: 0.0)
    }
    
    @objc func userInputEnded(notification: NSNotification) {
        placeOrderScrollView.contentInset = UIEdgeInsets.zero //Revert Scroll View to previous position
        placeOrderScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
