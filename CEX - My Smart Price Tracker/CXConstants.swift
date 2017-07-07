//
//  CXConstants.swift
//  CEX - My Smart Price Tracker
//
//  Created by Ashish Kapoor on 23/06/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

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

// Copyright stuff
let RFAboutViewCopyright =
        "Copyright (c) 2016 René Fouquet <mail@fouquet.me>" +
        "\n\n" +
        "Permission is hereby granted, free of charge, to any person obtaining a copy" +
        "of this software and associated documentation files (the \"Software\"), to deal" +
        "in the Software without restriction, including without limitation the rights" +
        "to use, copy, modify, merge, publish, distribute, sublicense, and/or sell" +
        "copies of the Software, and to permit persons to whom the Software is" +
        "furnished to do so, subject to the following conditions:" +
        "\n\n" +
        "The above copyright notice and this permission notice shall be included in" +
        "all copies or substantial portions of the Software." +
        "\n\n" +
        "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR" +
        "IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY," +
        "FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE" +
        "AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER" +
        "LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM," +
        "OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN" +
        "THE SOFTWARE."

let ChartsCopyright =
        "Copyright 2016 Daniel Cohen Gindi & Philipp Jahoda\n\n" +
        "Licensed under the Apache License, Version 2.0 (the \"License\"); you may not use this file except in compliance with the License. You may obtain a copy of the License at\n\n" +
        "http://www.apache.org/licenses/LICENSE-2.0\n\n" +
        "Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an \"AS IS\" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License."

let requestGAD = GADRequest()

