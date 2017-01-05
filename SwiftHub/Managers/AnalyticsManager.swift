//
//  AnalyticsManager.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import ARAnalytics
import Mixpanel
import Fabric
import Crashlytics

/// Manager for working with analytics
class Analytics {

    /// A global setup analytics API, keys are provided at the bottom of the documentation.
    class func setup() {
        Analytics.setupMixpanel(withToken: Configs.Keys.MixpanelAPIClientKey)
        Analytics.setupCrashlytics()
    }

    private class func setupMixpanel(withToken: String) {
        ARAnalytics.setupMixpanel(withToken: Configs.Keys.MixpanelAPIClientKey)
        Mixpanel.sharedInstance().enableLogging = false
    }

    private class func setupCrashlytics() {
        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = false
    }
}

extension Analytics {

    /// Register a user and an associated email address, it is fine to send nils for either.
    class func identifyUser(withID userID: String!, andEmailAddress email: String!) {

    }

    /// Set a per user property
    class func setUserProperty(_ property: String!, toValue value: Any!) {

    }

    /// Adds to a user property if support exists in the provider
    class func incrementUserProperty(_ counterName: String!, byInt amount: Int) {

    }

    /// Submit user events to providers
    class func event(_ event: String!) {
        ARAnalytics.event(event)
        Answers.logCustomEvent(withName: event, customAttributes: nil)
    }

    /// Submit user events to providers with additional properties
    class func event(_ event: String!, withProperties properties: [String : Any]!) {
        ARAnalytics.event(event, withProperties: properties)
        Answers.logCustomEvent(withName: event, customAttributes: properties)
    }

    /// Adds super properties, these are properties that are sent along with
    /// in addition to the event properties.
    class func addEventSuperProperties(_ superProperties: [String : Any]!) {

    }

    /// Removes a super property from the super properties.
    open class func removeEventSuperProperty(_ key: String!) {

    }

    /// Removes super properties from the super properties.
    class func removeEventSuperProperties(_ keys: [Any]!) {

    }

    /// Submit errors to providers
    class func error(_ error: Error!) {

    }

    /// Submit errors to providers with an associated message
    class func error(_ error: Error!, withMessage message: String!) {

    }

    /// Monitor Navigation changes as page view
    class func pageView(_ pageTitle: String!) {

    }

    /// Monitor Navigation changes as page view with additional properties
    class func pageView(_ pageTitle: String!, withProperties properties: [String : Any]!) {

    }

    /// Monitor a navigation controller, submitting each [ARAnalytics pageView:] on didShowViewController
    class func monitorNavigationController(_ controller: UINavigationController!) {

    }

    /// Let ARAnalytics deal with the timing of an event
    class func startTimingEvent(_ event: String!) {

    }

    /// Trigger a finishing event for the timing
    class func finishTimingEvent(_ event: String!) {

    }

    /// @warning the properites must not contain the key string `length` .
    class func finishTimingEvent(_ event: String!, withProperties properties: [String : Any]!) {

    }
}
