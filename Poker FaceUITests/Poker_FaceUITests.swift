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
        UserDefaults.standard.set(true, forKey: "hasSeenDisclaimer")
        continueAfterFailure = false
        app.launch()
    }

    @MainActor
    func testGlobalQuickReference() throws {
        if UIDevice.current.userInterfaceIdiom == .pad {
            throw XCTSkip("iPad hides the global quick reference button")
        }
        XCTAssertTrue(app.buttons["globalQuickReferenceButton"].isHittable)
        app.buttons["globalQuickReferenceButton"].tap()
        XCTAssertTrue(app.staticTexts["Royal Flush"].isHittable)
        XCTAssertFalse(app.buttons["localQuickReferenceButton"].isHittable)
    }
    
    @MainActor
    func testLocalQuickReference() throws {
        XCTAssertTrue(app.staticTexts["Screwball"].isHittable)
        app.staticTexts["Screwball"].tap()
        XCTAssertTrue(app.buttons["localQuickReferenceButton"].isHittable)
        app.buttons["localQuickReferenceButton"].tap()
        XCTAssertTrue(app.staticTexts["Straight Flush"].isHittable)
        XCTAssertFalse(app.buttons["globalQuickReferenceButton"].isHittable)
    }
    
    @MainActor
    func testRandomGamePicker() throws {
        XCTAssertTrue(app.buttons["randomGamePickerButton"].isHittable)
        app.buttons["randomGamePickerButton"].tap()
        XCTAssertFalse(app.buttons["playRandomGameButton"].isHittable)
        XCTAssertTrue(app.buttons["pickRandomGameButton"].isHittable)
        app.buttons["pickRandomGameButton"].tap()
        XCTAssertTrue(app.buttons["playRandomGameButton"].isHittable)
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
