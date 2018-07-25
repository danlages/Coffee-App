//
//  Destination.swift
//  To-Go
//
//  Created by Dan Lages on 04/07/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import Foundation
import UIKit


class Destination
{
    //MARK: Declaration
    
    var name: String
    var email: String
    var password: String
    var addressNo: Int
    var addressStreet: String
    var addressPostcode: String
    var openingTime: String
    var closingTime: String
    var takingOrders: Bool
    var verification: Bool
    
    //MARK: Initialization

    init?(name: String, email: String, password: String, addressNo: Int, addressStreet: String, addressPostcode: String, openingTime: String, closingTime: String, takingOrders: Bool, verification: Bool)
    {
        guard !name.isEmpty else //guard statement: Must be true for code after statement to be executed
        {
            return nil // Name of Destination is required
        }
        
        self.name = name
        self.email = email
        self.password = password
        self.addressNo = addressNo
        self.addressStreet = addressStreet
        self.addressPostcode = addressPostcode
        self.openingTime = openingTime
        self.closingTime = closingTime
        self.takingOrders = takingOrders
        self.verification = verification
        
    }

}

//



