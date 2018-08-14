//
//  MenuItem.swift
//  To-Go
//
//  Created by Sophie Traynor on 29/07/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import Foundation
import UIKit

class MenuItem
{
    //MARK: Declaration
    
    var name: String
    var size: String
    var price: Float
    
    //MARK: Initialization
    
    init?(name: String, size: String, price: Float)
    {
        guard !name.isEmpty else //guard statement: Must be true for code after statement to be executed
        {
            return nil // Name of Menu Item is required
        }
        
        self.name = name
        self.size = size
        self.price = price
    }
    
}
