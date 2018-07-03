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
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testScreenshotSearch() {
        let app = XCUIApplication()

        // Search Repository screen
        let searchSearchField = app.searchFields["Search"]
        searchSearchField.tap()
        app/*@START_MENU_TOKEN@*/.keys["R"]/*[[".keyboards.keys[\"R\"]",".keys[\"R\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["l"]/*[[".keyboards.keys[\"l\"]",".keys[\"l\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["m"]/*[[".keyboards.keys[\"m\"]",".keys[\"m\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.buttons["Cancel"].tap()
        snapshot("01_search_repository_screen")

        let swifthubSearchviewNavigationBar = app.navigationBars["SwiftHub.SearchView"]
        swifthubSearchviewNavigationBar/*@START_MENU_TOKEN@*/.buttons["Users"]/*[[".staticTexts.buttons[\"Users\"]",".buttons[\"Users\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("02_search_user_screen")

        swifthubSearchviewNavigationBar/*@START_MENU_TOKEN@*/.buttons["Repositories"]/*[[".staticTexts.buttons[\"Repositories\"]",".buttons[\"Repositories\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["realm-cocoa"]/*[[".cells.staticTexts[\"realm-cocoa\"]",".staticTexts[\"realm-cocoa\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("03_repository_details_screen")

        app.navigationBars["SwiftHub.RepositoryView"].buttons["Back"].tap()
    }
}
