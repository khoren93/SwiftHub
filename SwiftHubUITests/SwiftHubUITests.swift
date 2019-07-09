//
//  SwiftHubUITests.swift
//  SwiftHubUITests
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import XCTest

class SwiftHubUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testScreenshotSettings() {
        let element = XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 3).tap()
        sleep(1)
        element.children(matching: .other).element(boundBy: 1).tap()
        sleep(1)
        element.children(matching: .other).element(boundBy: 3).tap()

        sleep(5)
        snapshot("03_settings_screen")
    }

    func testScreenshotRepositoryDetails() {
        let app = XCUIApplication()

        let tablesQuery = app.tables
        tablesQuery.staticTexts["GitHub iOS client in RxSwift and MVVM-C clean architecture"].tap()

        sleep(5)
        snapshot("02_repository_details_screen")
    }

    func testScreenshotSearch() {
        sleep(5)
        snapshot("01_search_repository_screen")
    }
}
