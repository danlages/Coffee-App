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

    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var sectionHeaders = [String]()
    var sectionsArray = [[String]]()
    
    var selectedItem = ""
    var selectedCafe = ""
    
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

    //MARK: - load extras for selected item
    private func loadExtras(){
        
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
                            var tempArray = [String]()
                            for document in (snapshot?.documents)! {
                                tempArray.append(document.documentID)
                            }
                            self.sectionsArray.append(tempArray)
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
        else
        {
            let extra = sectionsArray[indexPath.section][indexPath.row]
            cell.extra.text = extra
            cell.price.text = "£0.00"
        }

        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
