//
//  CXCurrencyLimit.swift
//  CEX - My Smart Price Tracker
//
//  Created by Ashish Kapoor on 24/06/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import Foundation

class CXTradeHistory: NSObject {
    var type: String?
//    var date: Date?
    var amount: String?
    var price: String?
    var tId: String?

    init(json: JSONDictionary) {
        super.init()
        
        guard let type      = json["type"] as? String else { return }
        self.type   = type
        
        guard let price     = json["price"] as? String else { return }
        self.price  = price
        
        guard let amount    = json["amount"] as? String else { return }
        self.amount = amount
        
        guard let tId       = json["tId"] as? String else { return }
        self.tId    = tId
        
//        guard let date      = json["date"] as? Date else { return }
//        self.date   = date
        
    }
    
}
