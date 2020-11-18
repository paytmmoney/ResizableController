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
        // test for custom initial top offset updated on client end
        XCTAssertEqual(presentedResizableVC.initialTopOffset, panHandler?.estimatedInitialTopOffset)

        // test for maximum top offset updated on client end
        XCTAssertEqual(presentedResizableVC.finalTopOffset, panHandler?.estimatedFinalTopOffset)

        // test for updated sliderbar colour on client end
        XCTAssertEqual(presentedResizableVC.sliderBackgroundColor, panHandler?.delegate?.sliderBackgroundColor)
    }

    func testFixedSizeControllerPositionHandlerDelegate() throws {
        panHandler = ResizableControllerObserver(in: presentedResizableVC.onView, duration: 0.3, delegate: presentedFixedSizeVC)
        // test for custom initial top offset for default implementation
        XCTAssertEqual(presentedFixedSizeVC.initialTopOffset, panHandler?.estimatedInitialTopOffset)

        // test for maximum top offset for default implementation
        XCTAssertEqual(presentedFixedSizeVC.finalTopOffset, panHandler?.estimatedFinalTopOffset)

        // test for updated sliderbar for default colour
        XCTAssertEqual(presentedFixedSizeVC.sliderBackgroundColor, panHandler?.delegate?.sliderBackgroundColor)
    }

}

/// Resizable controller with custom implementation
class ResizableControllerPositionHandlerMock: UIViewController, ResizableControllerPositionHandler {
    var initialTopOffset: CGFloat {
        500
    }

    var finalTopOffset: CGFloat {
        200
    }

    var sliderBackgroundColor: UIColor {
        UIColor.red.withAlphaComponent(0.5)
    }
}

/// Resizable controller with Default implementation
class FixedSizeControllerPositionHandlerMock: UIViewController, ResizableControllerPositionHandler {
}
