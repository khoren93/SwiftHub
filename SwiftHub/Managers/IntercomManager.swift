//
//  IntercomManager.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/16/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import Intercom

/// Manager for working with Intercom
class IntercomManager {

    /// A global setup Intercom API, keys are provided in Configs.swift.
    class func setup() {
        IntercomManager.setupIntercom(withApiKey: Keys.intercom.apiKey, forAppId: Keys.intercom.appId)
    }

    private class func setupIntercom(withApiKey apiKey: String, forAppId appId: String) {
        // Initialize Intercom
        Intercom.setApiKey(apiKey, forAppId: appId)
    }

    class func presentMessenger() {
        Intercom.presentMessenger()
    }
}
