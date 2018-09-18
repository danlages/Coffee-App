//
//  UpdateExtras.swift
//  To-Go
//
//  Created by Dan Lages on 17/09/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit
import FirebaseFirestore



class UpdateExtrasVC: UIViewController {

    
 
    //MARK: Properties
    
    @IBOutlet weak var updateExtrasTableView: UITableView!
    
    @IBAction func updateExtrasButton(_ sender: Any) {
        
    }
    
    var sectionHeaders = [String]()
    var sectionsArray = [[String]]()
    
    var selectedItem = ""
    var selectedCafe = ""
    
    var itemNumberToIncrement = 1
    
    var itemChecked = [[Bool]]()
    var orderItem = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        if sectionHeaders.count == 0 {
//            label.text = ""
//        }
//        else {
//            label.text = sectionHeaders[section]
//            label.backgroundColor = UIColor.lightGray
//        }
//
//        return label
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //set checkmark when clicked
//        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
//            itemChecked[indexPath.section][indexPath.row] = false
//        }
//        else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
//            itemChecked[indexPath.section][indexPath.row] = true
//        }
//    }
}
