//
//  Order.swift
//  To-Go
//
//  Created by Sophie Traynor on 21/08/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import Foundation
import UIKit

class OrderItems {
    
    //MARK: Declaration
    
    var order: [[String]]
    
    //MARK: Initialization
    
    init?(order: [[String]])
    {
        guard !order.isEmpty else //guard statement: Must be true for code after statement to be executed
        {
            return nil // at least 1 item is required in order
        }
        
        self.order = order
    }
    
}
