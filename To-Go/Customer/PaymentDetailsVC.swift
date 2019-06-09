//
//  PaymentDetailsVC.swift
//  To-Go
//
//  Created by Dan Lages on 21/02/2019.
//  Copyright © 2019 To-Go. All rights reserved.
//

import UIKit


class PaymentDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var itemsTableView: UITableView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    var minsToCollect = 0
    
    var menuItems  = [MenuItem]()  //Creates a mutable array of menu item objects - allowing for the addition of items after initilsation
    
    var orderItems = [OrderItems]()
    var orderPrices = [Float]()
    var orderRunningTotal = Float()
    
    var tableItemCells = [itemCell]()

    override func viewDidLoad() {
        super.viewDidLoad()
        priceLabel.text = "£" + String(orderRunningTotal)
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        loadOrderItems()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectPaymentDetailsTapRecogniser(_ sender: Any) {
        
        performSegue(withIdentifier: "selectPaymentType", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "makeOrderActive" {
            let destination = segue.destination as! ActiveOrder
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            let dataData = formatter.string(from: Date() + TimeInterval(minsToCollect))
            destination.orderItems = orderItems
            destination.orderPrices = orderPrices
            destination.orderRunningTotal = orderRunningTotal
        
            destination.setTimeForCollection = "Collect at: " + dataData
            destination.selectedMinutes = minsToCollect
        }
        
    }
    
    private func loadOrderItems() {
        
        let count = orderItems.count - 1
        var currentExtras = [String]()
        var currentSize = ""
        
        for i in 0...count{
            let itemName = orderItems[i].order[0][0]
            let itemCost = orderPrices[i]
            let extrasCount = orderItems[i].order[0].count - 1
            currentExtras = []
            
            for x in 2...extrasCount {
                currentExtras.append(orderItems[i].order[0][x])
                print(currentExtras[x-2])
            }
            currentSize = orderItems[i].order[0][1]
            
            tableItemCells.append(itemCell(open: false, item: itemName, size: currentSize, extras: currentExtras, cost: itemCost))
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableItemCells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableItemCells[section].open == true {
            return tableItemCells[section].extras.count + 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ViewOrderTableViewCell" //Name used to recognise cell prototype - set in attributes inspector
        
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ViewOrderTableViewCell else {
                fatalError("The Dequeued cell is not an instance of ViewOrderTableViewCell.")
            }
            
            cell.itemName.text = tableItemCells[indexPath.section].item
            cell.itemSize.text = tableItemCells[indexPath.section].size
            cell.itemCost.text = "£" + String(format:"%.02f", tableItemCells[indexPath.section].cost)
            return cell
        }
        else {
            /*guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SelectItemTableViewCell else {
             
             fatalError("The Dequeued cell is not an instance of SelectItemTableViewCell.")
             }
             cell.menuItemName.text = tableItemCells[indexPath.section].extras[dataIndex]*/
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellExtras") else {
                return UITableViewCell() }
            cell.textLabel?.text = tableItemCells[indexPath.section].extras[dataIndex]
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Edit") {
            (UITableViewRowAction, IndexPath) in
            
            
            print ("Options Selected")
        }
        let remove = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "Remove") {
            (UITableViewRowAction, indexPath) in
            //MUST delete at DataSource to delte frome table view
            //            self.order.remove(at: indexPath.row)
            //            self.viewOrderTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        
        edit.backgroundColor = accentColor
        remove.backgroundColor = UIColor.red
        
        return [remove,edit]
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
            //remove if indexPath.row == 0 if only want to close extras when clicked and nothing else
        }
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
