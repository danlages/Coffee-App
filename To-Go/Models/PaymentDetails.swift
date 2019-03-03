//
//  Cards.swift
//  To-Go
//
//  Created by Dan Lages on 02/03/2019.
//  Copyright © 2019 To-Go. All rights reserved.
//

import Foundation
import UIKit

class PaymentDetails {
    
    var cardHolderName: String?
    var cardNumber: String?
    var expiryMonth: String?
    var expiryYear: String?
    var securityCode: String?
    
    init?(cardHolderName: String, cardNumber: String, expiryMonth: String, expiryYear: String, securityCode: String)  {
        
        guard !cardNumber.isEmpty || !cardNumber.isEmpty else {
            return nil
        }
        
        guard !expiryMonth.isEmpty || !expiryYear.isEmpty || !securityCode.isEmpty else {
            
            return nil
        }
        
        self.cardHolderName = cardHolderName
        self.cardNumber = cardNumber
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.securityCode = securityCode
        
    }
    
}
