//
//  CXConstants.swift
//  CEX - My Smart Price Tracker
//
//  Created by Ashish Kapoor on 23/06/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import Foundation

public typealias JSON = Any
public typealias JSONDictionary = Dictionary<String, Any>
public typealias JSONArray = Array<Any>


public enum timeSpan {
    case aDay
    case aWeek
    case aMonth
}

//var timeSpanValue: [(timeSpan, Int)] = [
//    (.oneDay, 24),
//    (.oneWeek, 168),
//    (.oneMonth, 720)
//]

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
let priceStats = "price_stats"
let currencyLimits = "currency_limits"

let convertEthToUSD = "\(cryptocurrency.ETH.rawValue)/\(currency.USD.rawValue)"

let priceStatsURL = "\(cexURL)\(priceStats)/\(convertEthToUSD)/"
let currencyLimitsURL = "\(cexURL)\(currencyLimits)"
