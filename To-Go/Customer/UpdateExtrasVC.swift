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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        loadExtras()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
