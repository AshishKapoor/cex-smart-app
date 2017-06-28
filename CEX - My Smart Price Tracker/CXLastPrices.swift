//
//  CXLastPrices.swift
//  CEX - My Smart Price Tracker
//
//  Created by Ashish Kapoor on 27/06/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import Foundation

class CXLastPrices: NSObject {
    
    private var _symbol1: String?
    private var _symbol2: String?
    private var _lprice: String?
    
    override init() {
    }
    
    init(priceStatsData: JSONDictionary) {
        super.init()
        guard let parsedLastPrice   = priceStatsData["lprice"] as? String else {return}
        self._lprice    = parsedLastPrice
        guard let parsedSymbol1     = priceStatsData["symbol1"] as? String else {return}
        self._symbol1   = parsedSymbol1
        guard let parsedSymbol2     = priceStatsData["symbol2"] as? String else {return}
        self._symbol2   = parsedSymbol2
    }
    
    var lastPrice: String {
        set ( newValue ) {
            self._lprice = newValue
        } get {
            guard let lprice = self._lprice else { return "" }
            return lprice
        }
    }
    
    var symbol1: String {
        set ( newValue ) {
            self._lprice = newValue
        } get {
            guard let symbol1 = self._symbol1 else { return "" }
            return symbol1
        }
    }
    
    var symbol2: String {
        set ( newValue ) {
            self._lprice = newValue
        } get {
            guard let symbol2 = self._symbol2 else { return "" }
            return symbol2
        }
    }
}
