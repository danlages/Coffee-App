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
    
    @IBAction func placeOrderButtonAction(_ sender: Any) {
        validateEntry()
    }
    @IBOutlet weak var placeOrderScrollView: UIScrollView!
    
    var timePicker = UIPickerView()  //Picker for selecting time for collection
    let timePickerData = [String](arrayLiteral: "10 Minutes", "15 Minutes", "20 Minutes", "25 Minutes") //List of Time Options For collection
    let timesAvaliable = [10, 15, 20, 25]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.delegate = self
        timePicker.dataSource = self
        timePicker.backgroundColor = accentColor //Set Colour of Pikcer View
        self.nameForCollectionTextField.delegate = self
        self.selectPickupTimeTextField.delegate = self
        selectPickupTimeTextField.inputView = timePicker
        errorMessageLabel.text = "" //Do not display error upon load
       
        //Notify when keyboard/picker is present
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userInputPresent), name: UIApplication.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.userInputEnded), name: UIApplication.keyboardDidHideNotification, object: nil)
        
        navbar();
    }
    
    func navbar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        placeOrderButtonOutlet.layer.cornerRadius = 5 //Button Design
        
       
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
    
    func validateEntry() {
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
    
    //MARK: Scroll View Positioning
    
    @objc func userInputPresent(notification: NSNotification) {
        var currentStatus = notification.userInfo
        let insetSize = currentStatus![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect //set inset size to size of keyboard/picker
        placeOrderScrollView.contentInset = UIEdgeInsets(top: 0.0, left: 00, bottom: insetSize.height, right: 0.0) //Move Scroll view up to desired inset size
        placeOrderScrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 00, bottom: insetSize.height, right: 0.0)
    }
    
    @objc func userInputEnded(notification: NSNotification) {
        placeOrderScrollView.contentInset = UIEdgeInsets.zero //Revert Scroll View to previous position
        placeOrderScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
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
