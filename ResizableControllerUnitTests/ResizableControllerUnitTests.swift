//
//  ResizableControllerUnitTests.swift
//  ResizableControllerUnitTests
//
//  Created by Arjun Baru on 10/11/20.
//

import XCTest
import UIKit
@testable import ResizableController

class ResizableControllerUnitTests: XCTestCase {

    var presentedResizableVC : ResizableControllerPositionHandler = ResizableControllerPositionHandlerMock()
    var presentedFixedSizeVC : ResizableControllerPositionHandler = FixedSizeControllerPositionHandlerMock()
    var panHandler: ResizableControllerObserver?

    func testResizableControllerPositionHandlerDelegate() throws {
        panHandler = ResizableControllerObserver(in: presentedResizableVC.onView, duration: 0.3, delegate: presentedResizableVC)
        XCTAssertEqual(500, panHandler?.estimatedInitialTopOffset)
        XCTAssertEqual(ResizableConstants.maximumTopOffset, panHandler?.estimatedFinalTopOffset)
        XCTAssertEqual(UIColor.darkGray.withAlphaComponent(0.5), panHandler?.delegate?.sliderBackgroundColor)
    }

    func testFixedSizeControllerPositionHandlerDelegate() throws {
        panHandler = ResizableControllerObserver(in: presentedResizableVC.onView, duration: 0.3, delegate: presentedFixedSizeVC)
        XCTAssertEqual(ResizableConstants.maximumTopOffset, panHandler?.estimatedInitialTopOffset)
        XCTAssertEqual(ResizableConstants.maximumTopOffset, panHandler?.estimatedFinalTopOffset)
        XCTAssertEqual(UIColor.darkGray.withAlphaComponent(0.5), panHandler?.delegate?.sliderBackgroundColor)
    }

}

class ResizableControllerPositionHandlerMock: UIViewController, ResizableControllerPositionHandler {
    var initialTopOffset: CGFloat {
        500
    }
}

class FixedSizeControllerPositionHandlerMock: UIViewController, ResizableControllerPositionHandler {
}
