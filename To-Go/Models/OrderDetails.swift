//
//  OrderDetails.swift
//  To-Go
//
//  Created by Dan Lages on 03/11/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import Foundation
import UIKit

class OrderDetails {
    
    var iD: Int?
    var cafeID: Int?
    var cafeName: String?
    var cost: Float?
    var collected: Bool?
    var dateBooked: Date?
    var dateCollected: Date?

   // MARK: Initialization

    init?(iD: Int, cafeID: Int, cafeName: String, cost: Float, collected: Bool, dateBooked: Date, dateCollected: Date) {
        
        guard iD != 0 else {
            return nil // object not created
        }

        self.iD = iD
        self.cafeID = cafeID
        self.cafeName = cafeName
        self.cost = cost
        self.collected = collected
        self.dateBooked = dateBooked
        self.dateCollected = dateCollected
    }
    
}
