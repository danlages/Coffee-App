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
    
    var addCardChildReferenceVC: AddCardTableViewController?
    
    @IBOutlet weak var addCardScrollView: UIScrollView!
    @IBOutlet weak var AddCardContainerView: UIView!
    
    @IBOutlet weak var addCardButtonOutlet: UIButton!
    
    @IBAction func addCardButton(_ sender: Any) {
        //Perform action to trigger segue here
  
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userInputPresent), name: UIApplication.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.userInputEnded), name: UIApplication.keyboardDidHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    func saveContainerViewReference(vc:AddCardTableViewController){  //Method for implementing referenc between parent and continer views - Implemented in order to share varibales.
        self.addCardChildReferenceVC = vc
        
        cardHolderName = (self.addCardChildReferenceVC?.cardHolderNameTextBox.text)!
        cardNumber = (self.addCardChildReferenceVC?.cardNumberTextBox.text)!
        expiryMonth = (self.addCardChildReferenceVC?.expiryMonthTextBox.text)!
        expiryYear = (self.addCardChildReferenceVC?.expiryYearTextBox.text)!
        securityCode = (self.addCardChildReferenceVC?.securityCodeTextBox.text)!
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIButton, button === addCardButtonOutlet else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)

            return
            }
        
        
        paymentMethod = PaymentDetails(cardHolderName: cardHolderName, cardNumber: cardNumber, expiryMonth: expiryMonth, expiryYear: expiryYear, securityCode: securityCode)
        
        
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
