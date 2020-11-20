//
//  ResizablePresentedViewController.swift
//  ResizableControllerSample
//
//  Created by Arjun Baru on 05/11/20.
//

import UIKit
import ResizableController

class ResizablePresentedViewController: UIViewController {

    @IBOutlet weak var swipeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ResizablePresentedViewController: ResizableControllerPositionHandler {
    var initialTopOffset: CGFloat {
        500
    }

    func didMoveTopOffset(value: CGFloat) {
        if value == initialTopOffset {
            self.swipeLabel.text = "Swipe up to full size"
        }

        if value == finalTopOffset {
            self.swipeLabel.text = "Swipe down to half screen"
        }
    }
}
