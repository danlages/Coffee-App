//
//  PlaceOrderVC.swift
//  To-Go
//
//  Created by Daniel Lages on 07/06/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit

//MARK: TableViewCells

class PlaceOrderVC: UIViewController, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    //MARK:Properties
    
    @IBOutlet weak var locationNameLabel: UILabel!
    
    @IBOutlet weak var nameForCollectionTextField: UITextField!
    
    @IBOutlet weak var selectPickupTimeTextField: UITextField!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var placeOrderButtonOutlet: UIButton!
    
    @IBAction func placeOrderButton(_ sender: Any) {
        
        ValidateEntry()  //Button action
    }
    

    //MARK: Variables
    
    var timePicker = UIPickerView()  //Picker for selecting time for collection
    let timePickerData = [String](arrayLiteral: "10 Minutes", "15 Minutes", "20 Minutes", "25 Minutes") //List of Time Options For collection
    let timesAvaliable = [10, 15, 20, 25]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.delegate = self
        timePicker.dataSource = self
        selectPickupTimeTextField.inputView = timePicker
        self.nameForCollectionTextField.delegate = self
        
        errorMessageLabel.text = "" //Do not display error upon load
        navbar();
    }
    
    func navbar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        placeOrderButtonOutlet.layer.cornerRadius = 5 // Button Design
    }
    

    //MARK: Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return
//    }

    //Picker Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timePickerData.count //Set to number of time options
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timePickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent: Int) {
        selectPickupTimeTextField.text = timePickerData[row]
        dismissKeyboard()
    }
    
    //MARK: CollectionNameTextField
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorMessageLabel.text = ""
    }
    
    func textFieldShouldReturn(_ nameForCollectionTextField: UITextField) -> Bool {
        dismissKeyboard() //Exit keyboard when promted (Done Button)
        return true
    }
    
    //MARK: Place Order Code
    
    func ValidateEntry() {
        //Validate Text Fields
        let collectionName = nameForCollectionTextField.text
        let collectionTimeText = selectPickupTimeTextField.text
        
        if collectionName == "" && collectionTimeText == ""
        {
            errorMessageLabel.text = "Please enter collection name and time"
        }
        else if collectionTimeText == ""
        {
            errorMessageLabel.text = "Please enter a collection time"
        }
        else if collectionName == ""
        {
            errorMessageLabel.text = "Please enter a collection name"
            //Next Step
        }
    }
    
    
    
    func dismissKeyboard() {
        view.endEditing(true)
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
