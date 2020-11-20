//
//  UIView+Extension.swift
//
//  Created by Arjun Baru on 22/10/20.
//  Copyright © 2020 Paytm Money 🚀. All rights reserved.
//

import UIKit

extension UIView {
    /// Adds rounded corner to the view
    public func roundedCorners(withRadius radius: CGFloat) {
        layer.cornerRadius = radius
    }

    /// Helper function to layout constraint to edges
    /// - Parameter insets: Add inset to give padding from different edges
    public func edgesToSuperView(insets: UIEdgeInsets = .zero) {

        guard let superView = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: insets.bottom),
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: insets.left),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: insets.right)
        ])
    }
}

public struct ResizableConstants {
    public static let maximumTopOffset = UIScreen.main.bounds.height * 0.08
    public static let animationDuration: TimeInterval = 0.3
}


public extension UIViewController {

    /// An overload to implement Resizable Controller model presentation style.
    /// - Parameters:
    ///   - viewControllerToPresent: ViewController which conforms to ResizableControllerPositionHandler protocol, Refer to ResizableControllerPositionHandler documentation for use case
    ///   - animationDuration: Duration for animtion of view controller presenattion. Defaults to 0.3 seconds
    ///   - completion: Optional parameter to provide additional functionllity after controller is presented.
    func present(_ viewControllerToPresent: ResizableControllerPositionHandler,
                 animationDuration: TimeInterval = 0.3,
                 completion: (() -> Void)? = nil) {
        let viewController = ResizableContainerViewController(animationDuration: animationDuration,
                                                           childVC: viewControllerToPresent)
        self.present(viewController, animated: true, completion: completion)
    }
}


/// Helper ViewController to layout Resizable Controller Style.
class ResizableContainerViewController: UIViewController {
    private var transitionAnimator: UIViewControllerTransitioningDelegate?
    init(animationDuration: TimeInterval,
         childVC: UIViewController) {
        self.transitionAnimator = ResizableTransitioningController(animationDuration: animationDuration)
        super.init(nibName: nil, bundle: nil)

        setup()
        addChildVC(childVC)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup() {
        modalPresentationStyle = .custom
        transitioningDelegate = transitionAnimator
    }
    private func addChildVC(_ child: UIViewController) {
        view.addSubview(child.view)
        addChild(child)
        child.didMove(toParent: self)
    }
}
