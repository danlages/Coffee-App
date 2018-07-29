//
//  ActiveOrderVC.swift
//  To-Go
//
//  Created by Daniel Lages on 13/06/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit
import MapKit

class ActiveOrderVC: UIViewController {

    //MARK:Properties
    
    @IBOutlet weak var activeDestinationNameLabel: UILabel!
    
    @IBOutlet weak var activeDestinationMapView: MKMapView!
    
    @IBOutlet weak var activeOrderCountdownLabel: UILabel!
    
    @IBOutlet weak var activeOrderCostLabel: UILabel!
    
    @IBOutlet weak var activeOrderCollectionTimeLabel: UILabel!
    
    @IBOutlet weak var orderCollectedButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
