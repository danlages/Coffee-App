//
//  PaymentDetailsVC.swift
//  To-Go
//
//  Created by Dan Lages on 21/02/2019.
//  Copyright © 2019 To-Go. All rights reserved.
//

import UIKit

class PaymentDetailsVC: UIViewController {

     var minsToCollect = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ActiveOrder
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let dataData = formatter.string(from: Date() + TimeInterval(minsToCollect))
        
        destination.setTimeForCollection = "Collect at: " + dataData
        destination.selectedMinutes = minsToCollect
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
