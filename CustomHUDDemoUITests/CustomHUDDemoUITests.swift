//
//  CustomHUDDemoUITests.swift
//  CustomHUDDemoUITests
//
//  Created by Allen_Hsu on 2025/5/2.
//

import XCTest

final class CustomHUDDemoUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
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

    @MainActor
    func testHUDFlow() throws {
        let app = XCUIApplication()
        app.launch()

        let loadButton = app.buttons["顯示 LoadView"]
        XCTAssertTrue(loadButton.exists)
        loadButton.tap()

        let loadingText = app.staticTexts["加載中"]
        XCTAssertTrue(loadingText.waitForExistence(timeout: 2))

        let notExist = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: notExist, object: loadingText)
        _ = XCTWaiter.wait(for: [expectation], timeout: 5)

        let successButton = app.buttons["顯示成功"]
        XCTAssertTrue(successButton.exists)
        successButton.tap()
        XCTAssertTrue(app.windows.count > 1)
        sleep(2)
        XCTAssertTrue(app.windows.count == 1)

        let failButton = app.buttons["顯示失敗"]
        XCTAssertTrue(failButton.exists)
        failButton.tap()
        XCTAssertTrue(app.windows.count > 1)
        sleep(2)
        XCTAssertTrue(app.windows.count == 1)
    }
}
