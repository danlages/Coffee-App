//
//  AddCardViewController.swift
//  To-Go
//
//  Created by Dan Lages on 01/03/2019.
//  Copyright © 2019 To-Go. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userInputPresent), name: UIApplication.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.userInputEnded), name: UIApplication.keyboardDidHideNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var addCardScrollView: UIScrollView!
    @IBOutlet weak var AddCardContainerView: UIView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
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
