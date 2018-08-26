//
//  ActiveOrderVC.swift
//  To-Go
//
//  Created by Daniel Lages on 13/06/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore

class ActiveOrder: UIViewController, UITableViewDelegate, UITableViewDataSource{

    //MARK:Properties
    
    @IBOutlet weak var activeOrderDestinationLabel: UILabel!
    
    @IBOutlet weak var activeOrderMapView: MKMapView!
    
    @IBOutlet weak var activeOrderTimerLabel: UILabel!
    
    @IBOutlet weak var activeOrderCollectedButton: UIButton!

    @IBOutlet weak var activeOrderTableView: UITableView!
    
    
    var menuItems  = [MenuItem]()  //Creates a mutable array of menu item objects - allowing for the addition of items after initilsation
    var selectedCafe = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.activeOrderTableView.delegate = self
        self.activeOrderTableView.dataSource = self
        
        loadSampleMenuItems()
        
        // Do any additional setup after loading the view.
    }
    
    func buttonDesign() {
        activeOrderCollectedButton.layer.cornerRadius = 5
    }
    
    private func loadSampleMenuItems() {
        
        let db = Firestore.firestore()
        
        db.collection("Cafe").document(selectedCafe).collection("Menu").getDocuments { (snapshot, error) in
            if error != nil {
                print("Error loading Cafes: \(String(describing: error))")
            }
            else {
                for document in (snapshot?.documents)! {
                    item.name = document.data()["Name"] as? String ?? ""
                    item.price = document.data()["Price"] as? Float ?? 999.99
                    item.size = document.data()["Size"] as? String ?? ""
                    
                    guard let menuItem = MenuItem(name: item.name, size: item.size, price: item.price) else{
                        
                        fatalError("Unable to create the training ground menu item") //Error message
                    }
                    self.menuItems += [menuItem]
                }
                
                self.activeOrderTableView.reloadData()
            }
        }
        
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
        
        let menuItem = menuItems[indexPath.row]
        
        //Determine and set cell information
        
        cell.menuItemName.text = menuItem.name
        cell.menuItemSize.text = menuItem.size
        cell.menuItemPrice.text = String(menuItem.price)
        
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

}
