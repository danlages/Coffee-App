//
//  AddCafeAddressVC.swift
//  To-Go
//
//  Created by Dan Lages on 11/06/2019.
//  Copyright © 2019 To-Go. All rights reserved.
//

import UIKit
import MapKit

class AddCafeAddressVC: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var addAddressMapView: MKMapView!
    
    @IBOutlet weak var numberTextField: UITextField!
    
    @IBOutlet weak var streetTextField: UITextField!
    
    @IBOutlet weak var postcodeTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    
    
    var propertyNumber = ""
    var propertyStreet = ""
    var propertyPostcode = ""
    var propertyCity = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberTextField.delegate = self
        streetTextField.delegate = self
        postcodeTextField.delegate = self
        cityTextField.delegate = self
        
  

        
        // Do any additional setup after loading the view.
    }
    
    let locationManager = CLLocationManager() //Define Location manager object.
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Delegate function allows us to handle loaction information
            
        let geoCoder = CLGeocoder()
        // Determine location of each destination displayed in table view
        let destinationAddress = (propertyNumber + ", " + propertyStreet + ", " + propertyPostcode) //Group address variables to analyse the geo-location
        
        let locationMarker = MKPointAnnotation() //Set Marker for Coffee Locations
        locationMarker.title = "Your Cafe"
        
        geoCoder.geocodeAddressString(destinationAddress) {
            placemarks, error in
            let placemark = placemarks?.first
            
            let destLat = placemark?.location?.coordinate.latitude
            let destLong = placemark?.location?.coordinate.longitude
            _ = CLLocation(latitude: destLat!, longitude: destLong!) //Determine at set lat and long coordinates
            locationMarker.coordinate = CLLocationCoordinate2D(latitude: destLat!, longitude: destLong!) //Set Marker for location
            self.addAddressMapView.addAnnotation(locationMarker)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("Locations not gathered ") // If locations not gathered
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
