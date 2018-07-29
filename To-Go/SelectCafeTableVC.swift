//
//  SelectCafeTableVC.swift
//  To-Go
//
//  Created by Daniel Lages on 07/06/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit

class SelectCafeTableVC: UITableViewController {
    
    //MARK: Properties
    
    var destinations  = [Destination]()  //Creates a mutable array of destination objects - allowing for the addition of items after initilsation
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSampleDestinations()
        
        navbar()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func navbar()
    {
        navigationController?.navigationBar.prefersLargeTitles = true // Lage navigation bar
        let search = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = search
    }
    
    
    //MARK: Sample Data
    
    private func loadSampleDestinations() {
        
        guard let destination1 = Destination(name: "The Coffee Shop", email: "theCoffee@gmail.co,uk", password: "coffee", addressNo: 6, addressStreet: "PenarthStation", addressPostcode: "CF64 3QL", openingTime: "10:00", closingTime: "13:00", takingOrders: true, verification: true) else{
            
            fatalError("Unable to create the training ground destination") //Error message
        }
        
        destinations += [destination1]
        
    }

    // MARK: - Table view data source

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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
