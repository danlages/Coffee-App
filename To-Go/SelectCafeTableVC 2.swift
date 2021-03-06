//
//  SelectCafeTableVC.swift
//  To-Go
//
//  Created by Daniel Lages on 07/06/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseFirestore

struct cafe{
    static var name: String = ""
    static var email: String = ""
    static var addressNo: String = ""
    static var addressStreet: String = ""
    static var addressPostcode: String = ""
    static var openingTime: String = ""
    static var closingTime: String = ""
    static var takingOrders: Bool = true
}

class SelectCafeTableVC: UITableViewController, CLLocationManagerDelegate {
    
    //MARK: Properties
        
    var destinations  = [Destination]()  //Creates a mutable array of destination objects - allowing for the addition of items after initilsation
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadDestinations()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Set selected cafe so correct menu items show
        let destination = segue.destination as? SelectItemTableVC
        let cellIndex = tableView.indexPathForSelectedRow?.row
        
        destination?.selectedCafe = destinations[cellIndex!].name
    }
    
    func navbar()
    {
        navigationController?.navigationBar.prefersLargeTitles = true // Large navigation bar
        let search = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = search
    }
    
    //Check current time to auto display if cafe is taking orders
    func getCurrentTime() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        //NEED TO CHECK IF TIME ZONE IS GMT(WINTER) OR GMT+01(SUMMER)
        formatter.timeZone = TimeZone(identifier:"GMT+01")
        let currentTime = formatter.string(from: date)
        return currentTime
    }
    
    //MARK: Sample Data
    
    func loadDestinations() {
        //Load cafe information from firebase
        let db = Firestore.firestore()
        db.collection("Cafe").getDocuments { (snapshot, error) in
            if error != nil{
                print("Error loading Cafes: \(String(describing: error))")
            }
            else{
                for document in (snapshot?.documents)! {
                    
                    cafe.name = document.data()["Name"] as? String ?? ""
                    cafe.email = document.data()["Email"] as? String ?? ""
                    cafe.addressNo = document.data()["Address No."] as? String ?? ""
                    cafe.addressStreet = document.data()["Address Street"] as? String ?? ""
                    cafe.addressPostcode = document.data()["Address Postcode"] as? String ?? ""
                    cafe.openingTime = document.data()["Opening Time"] as? String ?? ""
                    cafe.closingTime = document.data()["Closing Time"] as? String ?? ""
                    cafe.takingOrders = document.data()["Taking Orders"] as? Bool ?? true
                    
                    
                    guard let destination = Destination(name: cafe.name, email: cafe.email, addressNo: cafe.addressNo, addressStreet: cafe.addressStreet, addressPostcode: cafe.addressPostcode, openingTime: cafe.openingTime, closingTime: cafe.closingTime, takingOrders: cafe.takingOrders) else{
                        
                        fatalError("Unable to create the training ground destination") //Error message
                    }
                    self.destinations += [destination]
                }
                self.tableView.reloadData()
            }
        }
  
        
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

        //CHECK IF CURRENT TIME IS BETWEEN OPENING AND CLOSING TO DETERMINE
        //IF CAFE IS TAKING ORDERS
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
