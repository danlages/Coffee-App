//
//  AddCardViewController.swift
//  To-Go
//
//  Created by Dan Lages on 01/03/2019.
//  Copyright © 2019 To-Go. All rights reserved.
//

import UIKit
import os.log

class AddCardViewController: UIViewController {

    var paymentMethod: PaymentDetails?
    var cardHolderName = ""
    var cardNumber = ""
    var expiryMonth = ""
    var expiryYear = ""
    var securityCode = ""
    
    
    @IBOutlet weak var addCardScrollView: UIScrollView!
    
    @IBOutlet weak var cardholderNameTextField: UITextField!
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    
    @IBOutlet weak var expiryMonthTextField: UITextField!
    
    @IBOutlet weak var expiryYearTextField: UITextField!
    
    @IBOutlet weak var securityCodeTextField: UITextField!
    
    @IBOutlet weak var addCardButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userInputPresent), name: UIApplication.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.userInputEnded), name: UIApplication.keyboardDidHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIButton, button === addCardButtonOutlet else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)

            return
            }
        
     
        
        cardHolderName = cardholderNameTextField.text!
        cardNumber = cardNumberTextField.text!
         expiryMonth = expiryMonthTextField.text!
        expiryYear = expiryYearTextField.text!
        securityCode = securityCodeTextField.text!
        os_log("saved")
        
        paymentMethod = PaymentDetails(cardHolderName: cardHolderName, cardNumber: cardNumber, expiryMonth: expiryMonth, expiryYear: expiryYear, securityCode: securityCode)
        
        //Perform action to trigger segue here
        
        
            //Access Container view text views here and apply to payment details class
        }
    
    @objc func userInputPresent(notification: NSNotification) {
        var currentStatus = notification.userInfo
        let insetSize = currentStatus![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect //set inset size to size of keyboard/picker
        addCardScrollView.contentInset = UIEdgeInsets(top: 0.0, left: 00, bottom: insetSize.height, right: 0.0) //Move Scroll view up to desired inset size
        addCardScrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 00, bottom: insetSize.height, right: 0.0)
    }
    
    @objc func userInputEnded(notification: NSNotification) {
        addCardScrollView.contentInset = UIEdgeInsets.zero //Revert Scroll View to previous position
        addCardScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

}
