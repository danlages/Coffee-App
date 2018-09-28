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
    
    @IBOutlet weak var addToOrderButtonOutlet: UIButton!
    
    
    var sectionHeaders = ["Sizes", "Extras"]
    var sectionsArray = [[String]]()
    var sectionPrices = [[Float]]()
    
    var selectedItem = ""
    var selectedCafe = ""
    var itemPrice: Float = 0.00
    var itemPriceReset: Float = 0.00
    
    var itemNumberToIncrement = 1
    
    var itemChecked = [[Bool]]()
    var orderItem = [String]()
    
    var sizesLoaded = false
    var extrasLoaded = false
    
    var sizesSelected = false
        
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
        destination.orderItemPrice = itemPriceReset
        destination.orderRunningTotal = destination.orderRunningTotal + itemPrice
        destination.basketCount = destination.basketCount + self.itemNumberToIncrement //Increment basket to reflect updated number of items added to order
        destination.navbar() //Update Basket UI View
    }
    
    @IBAction func AddToOrderBtnTapped(_ sender: UIButton) {
        if sizesSelected == false {
                addToOrderButtonOutlet.setTitle("Select Size", for: .normal) //Update Add Button with instructions
            }
        else {
                getSelectedItems()
                performSegue(withIdentifier: "unwindToSelectItem", sender: self)
            }
    }
    
    private func getSelectedItems() {
        
        orderItem.append(selectedItem)
        var tempIndex = 0
        
        for(section, item) in sectionsArray.enumerated() {
            
            tempIndex = 0
            
            for extra in item {
                if itemChecked[section][tempIndex] == true {
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
                let defaultCheckmarkIndex = 0
                
                for document in (snapshot?.documents)! {
                    tempArray.append(document.documentID)
                    boolTempArray.append(false)
                    pricesTempArray.append(Float(document.data()["Additional Cost"] as! NSNumber.FloatLiteralType))
                }
                
                boolTempArray[defaultCheckmarkIndex] = true
                self.sizesLoaded = true
                
                self.sectionsArray.append(tempArray)
                self.itemChecked.append(boolTempArray)
                self.sectionPrices.append(pricesTempArray)
                self.tableView.reloadData()
                
            }
            
            //Load Extras
            db.collection("Cafe").document(self.selectedCafe).collection("Menu").document(self.selectedItem).collection("Extras").getDocuments { (snapshot, error) in
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
                    
                    self.extrasLoaded = true
                    
                    self.sectionsArray.append(tempArray)
                    self.itemChecked.append(boolTempArray)
                    self.sectionPrices.append(pricesTempArray)
                    self.tableView.reloadData()
                }
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
        
        if sizesLoaded == true && extrasLoaded == true && indexPath.section == 0 {
            if itemChecked[indexPath.section][indexPath.row] == true {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
                let extraPrice = sectionPrices[indexPath.section][indexPath.row]
                itemPriceReset = itemPrice //Second running total for selections updates
                itemPrice = itemPrice + extraPrice
                sizesSelected = true //Size has been Selected
                reloadItemCost() //Update Label
            }
            else {
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let extraPrice = sectionPrices[indexPath.section][indexPath.row]
        
        //set checkmark when clicked
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none  //If checkmark is present remove checkmark
            itemChecked[indexPath.section][indexPath.row] = false //Remove Item From item checked array
            
            if indexPath.section != 0 { //If item deselected is size otion
                itemPriceReset = itemPriceReset - extraPrice //Update Base price to remove size pricde
            }
            else {
                sizesSelected = false //Size is not selected
            }
            itemPrice = itemPrice - extraPrice //Remove price from running total
        }

        else {
            //loop through section to uncheck all items in size section
             let rowCount = tableView.numberOfRows(inSection: 0) //Define number of rows in section
             if indexPath.section == 0 { //If a size is selected
                for row in 0..<rowCount {
                    tableView.cellForRow(at: IndexPath(row: row, section: 0))?.accessoryType = UITableViewCell.AccessoryType.none //Clear checkmarks for rows in size section
                    itemChecked[indexPath.section][indexPath.row] = false
                    itemPrice = itemPriceReset //Set to base price of item as no size is selected
                    }
                }
             tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark //Apply Checkmark
             itemChecked[indexPath.section][indexPath.row] = true
             if indexPath.section != 0 {
                itemPriceReset = itemPriceReset + extraPrice //Update price if extra selected
             }
             else {
                sizesSelected = true //Size has been selected
                addToOrderButtonOutlet.setTitle("Add to Order", for: .normal) //Update Instructions
            }
            
            itemPrice = itemPrice + extraPrice //Update Price with order
         }
            reloadItemCost()
        }
}

