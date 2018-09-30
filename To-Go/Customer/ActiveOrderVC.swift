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

class ActiveOrder: UIViewController, UITableViewDelegate, UITableViewDataSource{

    //MARK:Properties
    
    @IBOutlet weak var activeOrderDestinationLabel: UILabel!
    
    @IBOutlet weak var activeOrderMapView: MKMapView!
    
    @IBOutlet weak var activeOrderTimerLabel: UILabel!
    
    @IBOutlet weak var activeOrderCollectionNameLabel: UILabel!
    
    @IBOutlet weak var activeOrderTimeToCollectLabel: UILabel!
    
    @IBOutlet weak var activeOrderCollectedButton: UIButton!

    @IBOutlet weak var activeOrderTableView: UITableView!
    
    var menuItems  = [MenuItem]()  //Creates a mutable array of menu item objects - allowing for the addition of items after initilsation
    var selectedCafe = ""
    
    var timer = Timer()
    
    var selectedMinutes = 0
    var setTimeForCollection = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.activeOrderTableView.delegate = self
        self.activeOrderTableView.dataSource = self
        self.activeOrderTimeToCollectLabel.text = setTimeForCollection
        loadSampleMenuItems()
        buttonDesign()
        operateTimer()
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
