//
//  FixedHeightPresentedViewController.swift
//  ResizableControllerSample
//
//  Created by Arjun Baru on 04/11/20.
//

import UIKit
import ResizableController

class FixedHeightPresentedViewController: UIViewController {

    @IBOutlet weak var swipeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FixedHeightPresentedViewController: ResizableControllerPositionHandler {}
