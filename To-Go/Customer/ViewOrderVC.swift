//
//  EditOrderTableVC.swift
//  To-Go
//
//  Created by Dan Lages on 06/08/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//


import UIKit

struct itemCell{
    var open = Bool()
    var item = String()
    var extras = [String]()
}

class ViewOrderVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    //MARK: Properties
    
    @IBOutlet weak var viewOrderTableView: UITableView!
    
    var menuItems  = [MenuItem]()  //Creates a mutable array of menu item objects - allowing for the addition of items after initilsation
    
    var order = [Order]()
    
    var tableItemCells = [itemCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewOrderTableView.delegate = self
        viewOrderTableView.dataSource = self
        
        loadSampleMenuItems()
        
        navbar()
        
        print("ORDER IN VIEW ORDER VC")
        dump(order)
    }
    //MARK: Navigation Bar and Search
    
    func navbar() {
        navigationController?.navigationBar.prefersLargeTitles = true // Laege navigation bar
        let search = UISearchController(searchResultsController: nil) // Search Bar Impelmentation
        self.navigationItem.searchController = search
    }
    
    func displayActionSheet() {
        let actionSheet = UIAlertController(title: "Item Selected", message: "Would you like to edit or delete this item?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) {
            (alert:UIAlertAction!) in
            print("Delete Selected")
        }
        
        let editAction = UIAlertAction(title: "Edit Extras", style: .default) { (alert: UIAlertAction) in
            print("Edit Selected")
            
            //Display Extras VC
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (alert:UIAlertAction) in
            print("Cancel Selected")
        }
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(editAction)
        actionSheet.addAction(cancelAction)
        
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: Sample Data
    
    private func loadSampleMenuItems() {
        
        /*guard let menuItem1 = MenuItem(name: "Coffee", size: "Small", price: 2) else{
            
            fatalError("Unable to create the training ground menu item") //Error message
        }
        
        menuItems += [menuItem1]*/
        
        let count = order.count - 1
        var currentExtras = [String]()
        
        for i in 0...count{
            let itemName = order[i].order[0][0]
            let extrasCount = order[i].order[0].count - 1
            currentExtras = []
            
            for x in 1...extrasCount {
                currentExtras.append(order[i].order[0][x])
                print(currentExtras[x-1])
            }
            
            tableItemCells.append(itemCell(open: false, item: itemName, extras: currentExtras))
        }
        
    }
    
    // MARK: Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableItemCells.count
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableItemCells[section].open == true {
            return tableItemCells[section].extras.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SelectItemTableViewCell" //Name used to recognise cell prototype - set in attributes inspector
        
        /*guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SelectItemTableViewCell else {
            
            fatalError("The Dequeued cell is not an instance of SelectItemTableViewCell.")
        }
        
        let menuItem = menuItems[indexPath.row]
        
        //Determine and set cell information
        
        cell.menuItemName.text = menuItem.name
        cell.menuItemSize.text = menuItem.size
        cell.menuItemPrice.text = String(menuItem.price)
        
        return cell*/
        
        let dataIndex = indexPath.row - 1
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SelectItemTableViewCell else {
                
                fatalError("The Dequeued cell is not an instance of SelectItemTableViewCell.")
            }
            cell.menuItemName.text = tableItemCells[indexPath.section].item
            return cell
            
        } else {
            /*guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SelectItemTableViewCell else {
                
                fatalError("The Dequeued cell is not an instance of SelectItemTableViewCell.")
            }
            cell.menuItemName.text = tableItemCells[indexPath.section].extras[dataIndex]*/
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellExtras") else {return UITableViewCell()}
            cell.textLabel?.text = tableItemCells[indexPath.section].extras[dataIndex]
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //displayActionSheet() //Display delete option to user via action sheet when cell selected
        if indexPath.row == 0 {
            if tableItemCells[indexPath.section].open == true{
                tableItemCells[indexPath.section].open = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
                tableItemCells[indexPath.section].open = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        } else {
            //something to happen when an extra is clicked?
            //remove if indexPath.row == 0 if want to close extras when clicked
        }
        
    }
}
