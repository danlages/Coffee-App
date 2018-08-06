//
//  SelectCafeTableVC.swift
//  To-Go
//
//  Created by Daniel Lages on 07/06/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit
import CoreLocation

class SelectCafeTableVC: UITableViewController, CLLocationManagerDelegate {
    
    //MARK: Properties
        
    var destinations  = [Destination]()  //Creates a mutable array of destination objects - allowing for the addition of items after initilsation
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSampleDestinations()
        navbar()
        
        locationManager.delegate = self //CLLocationManager Delegate
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization() //Only require information when app is in the forground
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100 //Only update distance information when user has moved given number of meters from previous update to improve efficiency
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func navbar()
    {
        navigationController?.navigationBar.prefersLargeTitles = true // Large navigation bar
        let search = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = search
    }
    
    //MARK: Sample Data
    
    private func loadSampleDestinations() {
        
        guard let destination1 = Destination(name: "The Coffee Shop", email: "theCoffee@gmail.co,uk", password: "coffee", addressNo: "2", addressStreet: "Portmanmoor Road", addressPostcode: "CF24 5HQ", openingTime: "10:00", closingTime: "13:00", takingOrders: true, verification: true) else{
            
            fatalError("Unable to create the training ground destination") //Error message
        }
        
        destinations += [destination1]
        
    }
    
    //MARK: Determine Distance Using Core Location API
    
    let locationManager = CLLocationManager() //Define Location manager object.
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Delegate function allows us to handle loaction information
        let location:CLLocationCoordinate2D = manager.location!.coordinate //Determine user location
        let userLat = location.latitude
        let userLong = location.longitude
        let userLocation = CLLocation(latitude: userLat, longitude: userLong)
        
        let geoCoder = CLGeocoder()
        
        for dest in destinations {
            // Determine location of each destination displayed in table view
            let destinationAddress = (dest.addressNo + ", " + dest.addressStreet + ", " + dest.addressPostcode) //Group address variables to analyse the geo-location
            geoCoder.geocodeAddressString(destinationAddress) {
                placemarks, error in
                let placemark = placemarks?.first
                
                let destLat = placemark?.location?.coordinate.latitude
                let destLong = placemark?.location?.coordinate.longitude
                let destCoordinates = CLLocation(latitude: destLat!, longitude: destLong!) //Determine at set lat and long coordinates
                let distance = String(format: "%2f km", destCoordinates.distance(from: userLocation) / 1000)
                
                print ("Distance in KM is: \(distance)")
            }
            //Filter table based on closest location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    //MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return destinations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SelectCafeTableViewCell" //Name used to recognise cell prototype - set in attributes inspector
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SelectCafeTableViewCell else {
            
            fatalError("The Dequeued cell is not an instance of SelectCafeTableViewCell.")
        }
        
        let destination = destinations[indexPath.row]
        
        //Determine and set cell information
        
        cell.destinatioNameLabel.text = destination.name
        cell.distanceLabel.text = "10 KM"

        if destination.takingOrders == true {
            cell.orderStatusLabel.text = "Avaliable for Orders"
        }

        else {
            cell.orderStatusLabel.text = "Not Taking Orders"
        }

        return cell
    }
    
    //MARK: Cell Actions
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let favouriteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Favourite", handler: {(action:UITableViewRowAction, indexPath: IndexPath) -> Void in
        
            //Enter Favourite code here
        })
        
        favouriteAction.backgroundColor = UIColor.lightGray //Colour of row action
        return [favouriteAction] //Return actions (variable names) here
    }
}
