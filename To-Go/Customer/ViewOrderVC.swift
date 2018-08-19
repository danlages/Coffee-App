//
//  EditOrderTableVC.swift
//  To-Go
//
//  Created by Dan Lages on 06/08/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//


import UIKit

class ViewOrder: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    //MARK: Properties
    
    
    @IBOutlet weak var viewOrderTableView: UITableView!
    
    var menuItems  = [MenuItem]()  //Creates a mutable array of menu item objects - allowing for the addition of items after initilsation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewOrderTableView.delegate = self
        viewOrderTableView.dataSource = self
        
        loadSampleMenuItems()
        
        navbar()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        
        guard let menuItem1 = MenuItem(name: "Coffee", size: "Small", price: 2) else{
            
            fatalError("Unable to create the training ground menu item") //Error message
        }
        
        menuItems += [menuItem1]
        
    }
    // MARK: Table view data source
    
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        displayActionSheet() //Display delete option to user via action sheet when cell selected
    }
}
