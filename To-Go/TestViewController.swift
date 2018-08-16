//
//  TestViewController.swift
//  To-Go
//
//  Created by Dan Lages on 15/08/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore

class TestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var testTableView: UITableView!
    
    let testMapView = MKMapView()
    
    
    var destinations  = [Destination]()  //Creates a mutable array of destination objects - allowing for the addition of items after initilisation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDestinations()
        
        self.testTableView.delegate = self
        self.testTableView.dataSource = self
        testTableView.contentInset = UIEdgeInsetsMake(400, 0, 0, 0)
        testTableView.estimatedRowHeight = testTableView.rowHeight
        
        testMapView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 400)
        testMapView.contentMode = .scaleAspectFill
        testMapView.clipsToBounds = true
        
        view.addSubview(testMapView)
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
                self.testTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 400 - (scrollView.contentOffset.y + 400)
        let height = min(max(y, 0), 600)
        
        testMapView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        self.testMapView.delegate = nil
        testMapView.isZoomEnabled = false
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
