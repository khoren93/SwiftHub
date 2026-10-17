//
//  SmokeTests.swift
//  SwiftHubUITests
//
//  Created by Khoren Markosyan on 10/18/26.
//  Copyright © 2026 Khoren Markosyan. All rights reserved.
//

import XCTest

/// Walks through the main screens without signing in, against the live GitHub API
final class SmokeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    @MainActor
    func testSearchRepositoryAndSettings() {
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()

        // Search repositories
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 15))
        searchField.tap()
        searchField.typeText("RxSwift")
        let table = app.tables.firstMatch
        XCTAssertTrue(table.cells.firstMatch.waitForExistence(timeout: 20))
        attachScreenshot(app, named: "1 search results")

        // Dragging the list hides the keyboard
        table.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.35))
            .press(forDuration: 0.1, thenDragTo: table.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.3)))
        XCTAssertTrue(app.keyboards.firstMatch.waitForNonExistence(timeout: 5))

        // Sort menu
        app.buttons["Best match ▼"].tap()
        attachScreenshot(app, named: "2 sort menu")
        app.buttons["Most stars"].tap()
        XCTAssertTrue(app.buttons["Most stars ▼"].waitForExistence(timeout: 10))
        XCTAssertTrue(table.staticTexts["ReactiveX/RxSwift"].waitForExistence(timeout: 20))

        // A page has 30 repositories; scrolling past them loads the next page
        for _ in 0..<15 {
            table.swipeUp(velocity: .fast)
        }
        sleep(3)
        for _ in 0..<5 {
            table.swipeUp(velocity: .fast)
        }
        attachScreenshot(app, named: "3 after scrolling past the first page")

        // Repository details
        for _ in 0..<20 {
            table.swipeDown(velocity: .fast)
        }
        table.staticTexts["ReactiveX/RxSwift"].tap()
        XCTAssertTrue(app.staticTexts["Source Code"].waitForExistence(timeout: 20))
        attachScreenshot(app, named: "4 repository details")
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Settings
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.staticTexts["Acknowledgements"].waitForExistence(timeout: 10))
        attachScreenshot(app, named: "5 settings")
    }

    private func attachScreenshot(_ app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
