//
//  EditPaymentOptionsTableViewController.swift
//  To-Go
//
//  Created by Dan Lages on 01/03/2019.
//  Copyright © 2019 To-Go. All rights reserved.
//

import UIKit
import os.log

class EditPaymentOptionsTableViewController: UITableViewController {

    var paymentMethods = [PaymentDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return paymentMethods.count
    }

    
//    @IBAction func unwindToPayments(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.source as? AddCardViewController, paymentMethod = sourceViewController.paymentMethod
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Represent cards in table view
        
        let cellIdentifier = "paymentMethodCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EditPaymentMethodTableViewCell else {
            fatalError("The dequeued cell is not an instance of EditPaymentMethodTableViewCell.")
        }
        
        let method = paymentMethods[indexPath.row]
        
        cell.paymentMethodTitle.text = method.cardNumber //Show card Number - need to show last 4 only

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case "addMethod":
            os_log("Send to Add Card", log:OSLog.default, type: .debug)
        case "ViewPaymentMethod":
             os_log("Send to View Card", log: OSLog.default, type: .debug)
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    @IBAction func unwindToMethodsList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddCardViewController, let
            paymentMethod = sourceViewController.paymentMethod {
            let newIndexPath = IndexPath(row:paymentMethods.count, section: 0)
            
            paymentMethods.append(paymentMethod)
            
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    


}
