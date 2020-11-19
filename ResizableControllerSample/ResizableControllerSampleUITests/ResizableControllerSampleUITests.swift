//
//  ResizableControllerSampleUITests.swift
//  ResizableControllerSampleUITests
//
//  Created by Arjun Baru on 10/11/20.
//

import XCTest

class ResizableControllerSampleUITests: XCTestCase {

    func testResizableController() throws {
        let app = XCUIApplication()
        app.launch()


        app.buttons["Show Custom Height Controller"].staticTexts["Show Custom Height Controller"].tap()

        let element2 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1)

        // Swipe to full screen
        element2.swipeUp()
        sleep(1)

        // swipe to half screen
        element2.swipeDown()
        sleep(1)

        // back tap to dismiss
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).tap()
    }

    func testFixedHeightController() throws {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Show Fixed Height Controller"].staticTexts["Show Fixed Height Controller"].tap()
        let element2 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1)

        // test swipe up on full screen
        element2.swipeUp()
        sleep(1)

        // swipe down to dismiss
        element2.swipeDown()
        sleep(1)
    }
}
