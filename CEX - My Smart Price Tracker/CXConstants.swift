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


enum TimeSpan {
    case oneDay, oneWeek, oneMonth
}

var timeSpanValue: [(TimeSpan, Int)] = [(.oneDay, 24), (.oneWeek, 24*7), (.oneMonth, 24*30)]

public enum priceStatsParam: String {
    case lastHours, maxRespArrSize
}

public enum cryptocurreny: String {
    case BTC, USD, EUR, ETH
}

public enum httpMethod: String {
    case GET, POST, PUT
}

let cexURL = "https://cex.io/api/"
let priceStats = "price_stats"
let currencyLimits = "currency_limits"

let convertEthToUSD = "\(cryptocurreny.ETH.rawValue)/\(cryptocurreny.USD.rawValue)"

let priceStatsURL = "\(cexURL)\(priceStats)/\(convertEthToUSD)/"
let currencyLimitsURL = "\(cexURL)\(currencyLimits)"
