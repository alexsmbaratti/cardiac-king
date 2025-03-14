//
//  Poker_FaceUITests.swift
//  Poker FaceUITests
//
//  Created by Alex Baratti on 3/7/25.
//

import XCTest

final class Poker_FaceUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    @MainActor
    func testUniversalQuickReference() throws {
        XCTAssertTrue(app.buttons["universalQuickReferenceButton"].isHittable)
        app.buttons["universalQuickReferenceButton"].tap()
        XCTAssertTrue(app.staticTexts["Royal Flush"].isHittable)
    }
    
    @MainActor
    func testScrewball() throws {
        XCTAssertTrue(app.staticTexts["Screwball"].isHittable)
        app.staticTexts["Screwball"].tap()
        
        // Ensure that text elements are visible
        XCTAssertTrue(app.staticTexts["King of Diamonds"].isHittable)
        XCTAssertTrue(app.staticTexts["A Pair of Natural Sevens"].isHittable)
        XCTAssertTrue(app.staticTexts["Play Standard Seven-Card Stud"].isHittable)
        
        // Ensure that deferred steps are shown after tapping the "Show Steps" button
        XCTAssertTrue(app.buttons["showDeferredStepsButton"].isHittable)
        app.buttons["showDeferredStepsButton"].tap()
        XCTAssertFalse(app.staticTexts["Play Standard Seven-Card Stud"].isHittable, "Deferred steps should be visible after tapping the button")
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
