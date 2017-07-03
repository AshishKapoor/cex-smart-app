//
//  CXTwitterTVC.swift
//  CEX - My Smart Price Tracker
//
//  Created by Ashish Kapoor on 03/07/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit
import TwitterKit

class CXTwitterTVC:TWTRTimelineViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Twitter Feed"
        let client = TWTRAPIClient()
        self.dataSource = TWTRListTimelineDataSource(listSlug: "CryptoCurrency", listOwnerScreenName: "swiftobjc", apiClient: client)
    }
}
