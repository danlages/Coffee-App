//
//  SelectItemVC.swift
//
//
//  Created by Dan Lages on 14/08/2018.
//

import UIKit
import FirebaseFirestore

struct item{
    static var name: String = ""
    static var price: Float = 999.99
    static var size: String = ""
}

class SelectItemVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var order = [Order]()
    var orderItem = [String]() //stores item with extras to add to order - recieved from add extras
    
    var menuItems  = [MenuItem]()  //Creates a mutable array of menu item objects - allowing for the addition of items after initilsation
    var basketCount = 0
    var selectedCafe = ""
    
    
    @IBOutlet weak var selectItemTableView: UITableView!
    @IBOutlet weak var viewOrderBtn: UIButton!
    @IBOutlet weak var viewOrderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectItemTableView.delegate = self
        self.selectItemTableView.dataSource = self
        
        loadMenuItems()
        
        navbar()
        
        if order.count == 0 {
            viewOrderView.isHidden = true
        }
    }
    
    
    
    @IBAction func unwindToSelectItem(segue:UIStoryboardSegue) {
        
    }
    
    //MARK: Navigation Bar and Search
    
    func navbar()
    {
        navigationController?.navigationBar.prefersLargeTitles = true // Large navigation bar
        let search = UISearchController(searchResultsController: nil) // Search Bar Impelmentation
        self.navigationItem.searchController = search
        
        let image = UIImage(named: "coffee-cup.png")
    
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        
        let imageView = UIImageView(image: image!)
      
        imageView.frame = CGRect(x: view.bounds.width-imageView.bounds.width, y: 0, width: 45, height: 45)
        view.addSubview(imageView)
        
        let label = UILabel(frame: CGRect(x: view.bounds.width-imageView.bounds.width + 12, y: 4.5, width: 45, height: 45))
        
        label.text = String(basketCount)
        view.addSubview(label)
        
        //Allow user Interaction for tap gesture seuge
        let basketTapGesture = UITapGestureRecognizer(target: self, action: #selector(SelectItemVC.basketSelected)) //Tap Gesture recogiser for for basket view
        view.addGestureRecognizer(basketTapGesture)
        view.isUserInteractionEnabled = true
        
        
        let barButtonItem = UIBarButtonItem(customView: view)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func basketSelected() { //Upon selection of basket
        self.performSegue(withIdentifier: "basket", sender: self)
    }
    
    
    //MARK: Menu load
    
    private func loadMenuItems() {
        
        let db = Firestore.firestore()
        
        db.collection("Cafe").document(selectedCafe).collection("Menu").getDocuments { (snapshot, error) in
            if error != nil {
                print("Error loading Cafes: \(String(describing: error))")
            }
            else {
                for document in (snapshot?.documents)! {
                    item.name = document.data()["Name"] as? String ?? ""
                    item.price = document.data()["Price"] as? Float ?? 999.99
                    item.size = document.data()["Size"] as? String ?? ""
                    
                    guard let menuItem = MenuItem(name: item.name, size: item.size, price: item.price) else{
                        
                        fatalError("Unable to create the training ground menu item") //Error message
                    }
                    self.menuItems += [menuItem]
                }
                
                self.selectItemTableView.reloadData()
            }
        }
        
    }
    
    //MARK: - Add to Order
    
    private func addToOrder(){
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //Seuge identifies the item selected, in preperation for server fetch
        let destination = segue.destination as? AddExtrasVC
        let cellIndex = selectItemTableView.indexPathForSelectedRow?.row
 
        destination?.selectedItem = menuItems[cellIndex!].name
        destination?.selectedCafe = selectedCafe
    }
    
    //MARK: - Table View
    
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
    
}
