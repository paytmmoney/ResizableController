//
//  ResizableTransitioningController.swift
//
//  Created by Arjun Baru on 25/04/20.
//  Copyright © 2020 Paytm Money 🚀. All rights reserved.
//

import UIKit

/// Manages present and dismiss for custom presented view controller
class ResizableTransitioningController: NSObject, UIViewControllerTransitioningDelegate {

    private let animationDuration: TimeInterval
    private var gestureRecoganiser: ResizableControllerObserver!
    private var transitionincontroller: ResizableAnimatedController?
    private var shouldProceedWithTransitioning = true

    init(animationDuration: TimeInterval = ResizableConstants.animationDuration) {
        self.animationDuration = animationDuration
    }

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {

        guard let presentedChildVc = presented.children.first as? ResizableControllerPositionHandler else {
            shouldProceedWithTransitioning = false
            return nil
        }

        gestureRecoganiser = ResizableControllerObserver(in: presented.view, duration: animationDuration, delegate: presentedChildVc)
        gestureRecoganiser.presentingVC = presenting
        gestureRecoganiser.estimatedInitialTopOffset = presentedChildVc.initialTopOffset

        self.transitionincontroller = ResizableAnimatedController(
            initialTopOffset: presentedChildVc.initialTopOffset,
            animationDuration: animationDuration,
            isPresenting: true,
            estimatedFinalTopOffset: presentedChildVc.finalTopOffset)

        transitionincontroller?.isPresenting = true
        return transitionincontroller
    }

    func animationController(forDismissed dismissed: UIViewController)
      -> UIViewControllerAnimatedTransitioning? {
        guard shouldProceedWithTransitioning else { return nil }
        transitionincontroller?.isPresenting = false
        return transitionincontroller
    }
}
