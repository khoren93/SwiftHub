//
//  AnalyticsManager.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import Mixpanel
import Fabric
import Crashlytics
import Intercom

/// Manager for working with analytics
class Analytics {

    static let mixpanel = Mixpanel.mainInstance()
    static let crashlytics = Crashlytics.sharedInstance()

    /// A global setup analytics API, keys are provided in Configs.swift.
    class func setup() {
        Analytics.setupMixpanel(withToken: Keys.mixpanel.apiKey)
    }

    private class func setupMixpanel(withToken token: String) {
        Mixpanel.initialize(token: token)
        Mixpanel.mainInstance().loggingEnabled = false
    }
}

extension Analytics {

    class func registerUnidentifiedUser() {
        // This registers an unidentifed user with Intercom.
        Intercom.registerUnidentifiedUser()
    }

    /// Register a user and an associated email address, it is fine to send nils for either.
    class func identifyUser(withID userId: String!, emailAddress email: String!) {
        mixpanel.identify(distinctId: userId)
        mixpanel.people.set(property: "$email", to: email)

        crashlytics.setUserIdentifier(userId)
        crashlytics.setUserEmail(email)

        // We’re logged in, we can register the user with Intercom.
        Intercom.registerUser(withUserId: userId, email: email)
    }

    class func updateUser(withName name: String?, emailAddress email: String?, phoneNumber phone: String?) {
        let attributes = ICMUserAttributes()

        if let name = name {
            mixpanel.people.set(property: "$name", to: name)
            crashlytics.setUserName(name)
            attributes.name = name
        }

        if let email = email {
            mixpanel.people.set(property: "$email", to: email)
            crashlytics.setUserEmail(email)
            attributes.email = email
        }

        if let phone = phone {
            mixpanel.people.set(property: "$phone", to: phone)
            crashlytics.setObjectValue(phone, forKey: "$phone")
            attributes.phone = phone
        }

        Intercom.updateUser(attributes)
    }

    /// Set a per user property
    class func setUserProperty(_ property: String!, toValue value: Any!) {
        mixpanel.people.set(property: property, to: (value as? MixpanelType)!)

        crashlytics.setObjectValue(value, forKey: property)
    }

    /// Adds to a user property if support exists in the provider
    class func incrementUserProperty(_ counterName: String!, byInt amount: Int) {
        mixpanel.people.increment(property: counterName, by: Double(amount))
    }

    /// Submit user events to providers
    class func event(_ event: String!) {
        mixpanel.track(event: event)

        Answers.logCustomEvent(withName: event, customAttributes: nil)

        Intercom.logEvent(withName: event)
    }

    /// Submit user events to providers with additional properties
    class func event(_ event: String!, withProperties properties: [String : Any]!) {
        mixpanel.track(event: event, properties: (properties as? Properties?)!)

        Answers.logCustomEvent(withName: event, customAttributes: properties)

        Intercom.logEvent(withName: event, metaData: properties)
    }

    /// Adds super properties, these are properties that are sent along with
    /// in addition to the event properties.
    class func addEventSuperProperties(_ superProperties: [String : Any]!) {
        mixpanel.registerSuperProperties((superProperties as? Properties)!)
    }

    /// Removes a super property from the super properties.
    class func removeEventSuperProperty(_ key: String!) {
        mixpanel.unregisterSuperProperty(key)
    }

    /// Submit errors to providers
    class func error(_ error: Error!) {
        crashlytics.recordError(error)
    }

    /// Submit errors to providers with an associated message
    class func error(_ error: Error!, withMessage message: String!) {
        crashlytics.recordError(error, withAdditionalUserInfo: ["message": message])
    }

    /// Monitor Navigation changes as page view
    class func pageView(_ pageTitle: String!) {
        Analytics.pageView(pageTitle, withProperties: [:])
    }

    /// Monitor Navigation changes as page view with additional properties
    class func pageView(_ pageTitle: String!, withProperties properties: [String : Any]!) {
        var props = properties
        props?["screen"] = pageTitle

        mixpanel.track(event: "Screen view", properties: (props as? Properties?)!)
        Answers.logContentView(withName: pageTitle, contentType: nil, contentId: nil, customAttributes: properties)
    }

    class func logout() {
        mixpanel.reset()

        Intercom.reset()
    }
}
