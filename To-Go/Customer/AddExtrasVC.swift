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
    
    var sectionHeaders = [String]()
    var sectionsArray = [[String]]()
    
    var selectedItem = ""
    var selectedCafe = ""
    
    var itemNumberToIncrement = 1
    
    var itemChecked = [[Bool]]()
    var orderItem = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        loadExtras()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! SelectItemVC
        destination.orderItem = orderItem //send item back to order
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
    
    //MARK: - load extras for selected item
    private func loadExtras() {
        
        let db = Firestore.firestore()
        
        db.collection("Cafe").document(selectedCafe).collection("Menu").document(selectedItem).collection("Collection Names").getDocuments { (snapshot, error) in
            if error != nil {
                print("Error loading Extras: \(String(describing: error))")
            }
            else {
                for document in (snapshot?.documents)! {
                    
                    self.sectionHeaders.append(document.documentID)
                }
                
                for i in 0...(self.sectionHeaders.count - 1) {
                    db.collection("Cafe").document(self.selectedCafe).collection("Menu").document(self.selectedItem).collection(self.sectionHeaders[i]).getDocuments(completion: { (snapshot, error) in
                        if error != nil {
                            print("Error loading section header documents: \(String(describing: error))")
                        }
                        else {
                            var boolTempArray = [Bool]()
                            var tempArray = [String]()
                            for document in (snapshot?.documents)! {
                                tempArray.append(document.documentID)
                                boolTempArray.append(false)
                            }
                            self.sectionsArray.append(tempArray)
                            self.itemChecked.append(boolTempArray)
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        }
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionsArray.count == 0 {
            return 1
        }
        else{
            return sectionsArray.count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionsArray.count == 0 {
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
        if sectionsArray.count == 0 {
            cell.extra.text = ""
            cell.price.text = ""
        }
        else {
            let extra = sectionsArray[indexPath.section][indexPath.row]
            cell.extra.text = extra
            cell.price.text = "£0.00"
        }

        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set checkmark when clicked
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            itemChecked[indexPath.section][indexPath.row] = false
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            itemChecked[indexPath.section][indexPath.row] = true
        }
    }
   
}
