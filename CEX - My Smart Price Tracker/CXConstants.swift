//
//  CXConstants.swift
//  CEX - My Smart Price Tracker
//
//  Created by Ashish Kapoor on 23/06/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import Foundation
import UIKit

public typealias JSON = Any
public typealias JSONDictionary = Dictionary<String, Any>
public typealias JSONArray = Array<Any>

public enum timeSpan {
    case aDay
    case aWeek
    case aMonth
}

func timeStampValue(timePeriod: timeSpan) -> Int {
    switch timePeriod {
    case .aDay:
        return 24
    case .aWeek:
        return 168
    case .aMonth:
        return 720
    }
}

public enum priceStatsParam: String {
    case lastHours, maxRespArrSize
}

public enum cryptocurrency: String {
    case BTC, ETH
}

public enum currency: String {
    case USD, EUR
}

public enum httpMethod: String {
    case GET, POST, PUT
}

let cexURL = "https://cex.io/api/"
let lastPrices = "last_prices/BTC/ETH/USD/EUR"

let priceStats = "price_stats"
let tradeHistory = "trade_history/ETH/USD/?since=0"


let convertEthToUSD = "\(cryptocurrency.ETH.rawValue)/\(currency.USD.rawValue)"
let priceStatsEthURL = "\(cexURL)\(priceStats)/\(convertEthToUSD)/"

let convertBtcToUSD = "\(cryptocurrency.BTC.rawValue)/\(currency.USD.rawValue)"
let priceStatsBtcURL = "\(cexURL)\(priceStats)/\(convertBtcToUSD)/"

let tradeHistoryURL = "\(cexURL)\(tradeHistory)"
let lastPricesURL = "\(cexURL)\(lastPrices)"

let appGreenColor = UIColor(colorLiteralRed: 0.31, green: 0.74, blue: 0.57, alpha: 1)
