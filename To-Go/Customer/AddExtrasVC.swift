//
//  AddExtrasTableVC.swift
//  To-Go
//
//  Created by Sophie Traynor on 14/08/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddExtrasVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedItemLbl: UILabel!
    @IBOutlet weak var itemCostLbl: UILabel!
    
    var sectionHeaders = ["Sizes", "Extras"]
    var sectionsArray = [[String]]()
    var sectionPrices = [[Float]]()
    
    var selectedItem = ""
    var selectedCafe = ""
    var itemPrice: Float = 0.00
    
    var itemNumberToIncrement = 1
    
    var itemChecked = [[Bool]]()
    var orderItem = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        loadExtras()
        
        selectedItemLbl.text = selectedItem
        itemCostLbl.text = "£" + String(format:"%.02f", itemPrice)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! SelectItemVC
        destination.orderItem = orderItem //send item back to order
        destination.orderItemPrice = itemPrice
        destination.orderRunningTotal = destination.orderRunningTotal + itemPrice
        destination.basketCount = destination.basketCount + self.itemNumberToIncrement //Increment basket to reflect updated number of items added to order
        destination.navbar() //Update Basket UI View
    }
    
    @IBAction func AddToOrderBtnTapped(_ sender: UIButton) {
        
        getSelectedItems()
        performSegue(withIdentifier: "unwindToSelectItem", sender: self)
    }
    
    private func getSelectedItems(){
        
        orderItem.append(selectedItem)
        var tempIndex = 0
        
        for(section, item) in sectionsArray.enumerated() {
            
            tempIndex = 0
            
            for extra in item {
                
                if itemChecked[section][tempIndex] == true {
                    print("extra: \(extra)")
                    orderItem.append(extra)
                }
                tempIndex += 1
            }
        }
        
        if orderItem.count == 1{
            print("no extras added")
        }
    }
    
    private func reloadItemCost(){
        itemCostLbl.text = "£" + String(format:"%.02f", itemPrice)
    }
    
    //MARK: - Load Extras from Firebase
    private func loadExtras() {
        
        let db = Firestore.firestore()
       
        //Load Sizes
        db.collection("Cafe").document(selectedCafe).collection("Menu").document(selectedItem).collection("Sizes").getDocuments { (snapshot, error) in
            if error != nil {
                print("Error loading Sizes: \(String(describing: error))")
            }
            else {
                var tempArray = [String]()
                var boolTempArray = [Bool]()
                var pricesTempArray = [Float]()
                
                for document in (snapshot?.documents)! {
                    tempArray.append(document.documentID)
                    boolTempArray.append(false)
                    pricesTempArray.append(Float(document.data()["Additional Cost"] as! NSNumber.FloatLiteralType))
                }
                
                self.sectionsArray.append(tempArray)
                self.itemChecked.append(boolTempArray)
                self.sectionPrices.append(pricesTempArray)
                self.tableView.reloadData()
            }
        }
        
        //Load Extras
        db.collection("Cafe").document(selectedCafe).collection("Menu").document(selectedItem).collection("Extras").getDocuments { (snapshot, error) in
                if error != nil {
                    print("Error loading Extras: \(String(describing: error))")
                } else {
                    var tempArray = [String]()
                    var boolTempArray = [Bool]()
                    var pricesTempArray = [Float]()
                    
                    for document in (snapshot?.documents)! {
                        
                        tempArray.append(document.documentID)
                        boolTempArray.append(false)
                        pricesTempArray.append(Float(document.data()["Additional Cost"] as! NSNumber.FloatLiteralType))
                    }
                    self.sectionsArray.append(tempArray)
                    self.itemChecked.append(boolTempArray)
                    self.sectionPrices.append(pricesTempArray)
                    self.tableView.reloadData()
                }
            }
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {

        return sectionHeaders.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if sectionsArray.count < sectionHeaders.count {
            return 1
        }
        else {
            return sectionsArray[section].count
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        if sectionHeaders.count == 0 {
            label.text = ""
        }
        else {
            label.text = sectionHeaders[section]
            label.backgroundColor = UIColor.lightGray
        }
    
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "AddExtrasTableViewCell" //Name used to recognise cell prototype - set in attributes inspector
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AddExtrasTableViewCell else {
            
            fatalError("The Dequeued cell is not an instance of SelectItemTableViewCell.")
        }
        if sectionsArray.count < sectionHeaders.count {
            cell.extra.text = ""
            cell.price.text = ""
        }
        else {
            let extra = sectionsArray[indexPath.section][indexPath.row]
            let price = sectionPrices[indexPath.section][indexPath.row]
            cell.extra.text = extra
            cell.price.text = "+ £" + String(format:"%.02f", price)
        }

        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //......NEED TO ADD CODE SO ONLY 1 SIZE CAN BE CLICKED AT A TIME
        
        let extraPrice = sectionPrices[indexPath.section][indexPath.row]
        
        //set checkmark when clicked
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none  //If checkmark is present - remove from item checked
            itemChecked[indexPath.section][indexPath.row] = false
            itemPrice = itemPrice - extraPrice
        }
            
        else{
            
            //loop through section to uncheck all items in size section.
            let rowCount = tableView.numberOfRows(inSection: 0) //Define number of rows in section
            for row in 0..<rowCount { //For all rows in section
                tableView.cellForRow(at: IndexPath(row: row, section: 0))?.accessoryType = UITableViewCell.AccessoryType.none //clear checkmarks for rows in size section
            }

            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark //Apply Checkmark
            itemChecked[indexPath.section][indexPath.row] = true
            itemPrice = itemPrice + extraPrice
        }
        
        reloadItemCost()
    }
    
    
   
}

