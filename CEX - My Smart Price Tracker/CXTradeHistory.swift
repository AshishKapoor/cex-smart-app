//
//  CXCurrencyLimit.swift
//  CEX - My Smart Price Tracker
//
//  Created by Ashish Kapoor on 24/06/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import Foundation

struct CXTradeHistory {
    let type: String
}

//struct Day {
//    
//    let date: Date
//    let min: Double
//    let max: Double
//    
//}
//
//extension Day: JSONDecodable {
//    
//    public init?(JSON: Any) {
//        guard let JSON = JSON as? [String: AnyObject] else { return nil }
//        
//        guard let time = JSON["time"] as? Double else { return nil }
//        guard let min = JSON["temperatureMin"] as? Double else { return nil }
//        guard let max = JSON["temperatureMax"] as? Double else { return nil }
//        
//        self.min = min
//        self.max = max
//        self.date = Date(timeIntervalSince1970: time)
//    }
//    
//}
