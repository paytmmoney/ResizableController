//
//  ResizableControllerObserver.swift
//
//  Created by Arjun Baru on 05/05/20.
//  Copyright © 2020 Paytm Money 🚀. All rights reserved.
//

import UIKit

/// Protocol to integrate Resizable Controller model presentation. To be conformed by the modally presented controller
public protocol ResizableControllerPositionHandler: UIViewController {

    /// Override this property if you do not want to include intuitive slide up indicator. Disabled by default for non-resizable views controllers.
    var shouldShowSlideUpIndication: Bool { get }

    /// Override this property to give differnent colour to Slider up indicator. Defaults to darkGrey with alpha 0.5
    var sliderBackgroundColor: UIColor { get }

    /// Override this property to give initial custom height, calculated from top.
    var initialTopOffset: CGFloat { get }

    /// Override this property to give custom final height, calculated from top. Resizable controller will change its height from initialTopOffset to finalTopOffset.
    var finalTopOffset: CGFloat { get }

    /// Override this property to add behaviours to view controller before it changes it size.
    /// - Parameter value: new top offset to which view controller will shifted position.
    func willMoveTopOffset(value: CGFloat)

    /// Override this property to add additional behaviours to view controller after it changes it size.
    /// - Parameter value: new top offset after view controller has shifted position
    func didMoveTopOffset(value: CGFloat)
}


extension ResizableControllerPositionHandler {
    var onView: UIView {
        return self.view
    }
}

// MARK: Public default Implementation for protocol

public extension ResizableControllerPositionHandler {

    func willMoveTopOffset(value: CGFloat) {
        if initialTopOffset == finalTopOffset || value > initialTopOffset {
            self.dismiss(animated: true, completion: nil)
        }
    }

    var sliderBackgroundColor: UIColor {
        UIColor.darkGray.withAlphaComponent(0.5)
    }

    var initialTopOffset: CGFloat {
        return ResizableConstants.maximumTopOffset
    }

    var finalTopOffset: CGFloat {
        return ResizableConstants.maximumTopOffset
    }

    var shouldShowSlideUpIndication: Bool {
        return initialTopOffset != finalTopOffset
    }

    func didMoveTopOffset(value: CGFloat) {}
}


/// This class is responsible for handling swipe related recoganisation.
/// It provides call backs on to ResizableControllerPositionHandler protocol conformed class once user interacts with the view controller.
/// Refer to ResizableControllerPositionHandler to see what observations can be subscibed
class ResizableControllerObserver: NSObject, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    private let panGesture = UIPanGestureRecognizer()
    private var viewPosition: SliderPosition = .present

    private weak var view: UIView?
    private let animationDuration: TimeInterval

    weak var delegate: ResizableControllerPositionHandler?
    weak var presentingVC: UIViewController?

    var estimatedFinalTopOffset = UIScreen.main.bounds.height * 0.08
    var estimatedInitialTopOffset = UIScreen.main.bounds.height * 0.55
    var presentingVCminY: CGFloat = 0
    private var gestureDidEndedState = true

    private lazy var slideIndicativeView: UIView = {
        let view = UIView()
        view.backgroundColor = delegate?.sliderBackgroundColor
        view.widthAnchor.constraint(equalToConstant: 55).isActive = true
        view.heightAnchor.constraint(equalToConstant: 5).isActive = true
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(in view: UIView, duration: TimeInterval = 0.3, delegate: ResizableControllerPositionHandler? = nil) {
        self.view = view
        self.animationDuration = duration
        super.init()

        setupDelegate(delegate)
        commonInit()
    }

    private func commonInit() {
        setupGestureRecoganisers()
        addSliderView()
    }

    private func setupGestureRecoganisers() {
        guard let view = view else { return }
        self.panGesture.addTarget(self, action: #selector(handlePan))
        self.panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }

    fileprivate func setupDelegate(_ delegate: ResizableControllerPositionHandler?) {
        self.delegate = delegate

        self.estimatedFinalTopOffset = delegate?.finalTopOffset ?? ResizableConstants.maximumTopOffset
        self.estimatedInitialTopOffset = delegate?.initialTopOffset ?? ResizableConstants.maximumTopOffset
    }


    /// handles user's swipe interactions
    @objc private func handlePan(_ gestureRecognizer: UIGestureRecognizer) {

        guard let currentView = panGesture.view,
            gestureRecognizer == panGesture,
            let _ = view else { return }

        switch panGesture.state {
        case .changed:
            guard gestureDidEndedState else { return }
            switch panGesture.dragDirection(inView: currentView) {
            case .upwards where !isHeightEqualToEstimatedHeight:
                translate(value: estimatedFinalTopOffset)
            case .downwards where isHeightEqualToEstimatedHeight:
                translate(value: estimatedInitialTopOffset)
            case .downwards:
                delegate?.willMoveTopOffset(value: UIScreen.main.bounds.maxY)
                delegate?.didMoveTopOffset(value: UIScreen.main.bounds.maxY)
            default:
                break
            }
            gestureDidEndedState = false
        case .ended, .failed, .cancelled:
            gestureDidEndedState = true
        default: break
        }
    }
}

// MARK: PanGesture Delegates
extension ResizableControllerObserver {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        guard let currentView = panGesture.view, gestureRecognizer == panGesture else {
            return false
        }

        switch panGesture.dragDirection(inView: currentView) {
        case .upwards where !isHeightEqualToEstimatedHeight:
            guard delegate?.initialTopOffset != delegate?.finalTopOffset else { return false }
            return true
        case .downwards:
            return true
        case .idle where !isHeightEqualToEstimatedHeight:
            return true
        default: return false
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let currentView = gestureRecognizer.view,
            let otherView = otherGestureRecognizer.view else {
                return false
        }

        let isPanGesture = gestureRecognizer == panGesture
        let isDescendant = otherView.isDescendant(of: currentView)

        guard isPanGesture && isDescendant else {
            return false
        }

        guard let scrollView = otherView as? UIScrollView else {
            return true
        }

        return scrollView.contentOffset.y == 0
    }
}

// MARK: All About View Transaltion

private extension ResizableControllerObserver {

    var isHeightEqualToEstimatedHeight: Bool {
        guard let view = view else { return false }
        return Int(view.frame.minY) == Int(estimatedFinalTopOffset)
    }

    /// performs resizable transformation for presented and presenting view controllers
    func translate(value: CGFloat) {
        delegate?.willMoveTopOffset(value: value)
        UIView.animate(withDuration: animationDuration, animations: {
            self.view?.frame.origin.y = value
            self.presentingViewTransaltion(transaltion: value)
        }, completion: { _ in
            self.delegate?.didMoveTopOffset(value: value)
            self.panGesture.setTranslation(.zero, in: self.view)
        })
    }

    func addSliderView() {
        guard let currentView = view, delegate?.shouldShowSlideUpIndication == true else { return }

        currentView.addSubview(slideIndicativeView)

        NSLayoutConstraint.activate([
            slideIndicativeView.centerXAnchor.constraint(equalTo: currentView.centerXAnchor),
            slideIndicativeView.topAnchor.constraint(equalTo: currentView.topAnchor, constant: 15)
        ])

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.addSliderAnimation()
        }
    }

    /// Scales presenting view controller as per translation
    func presentingViewTransaltion(transaltion: CGFloat) {
        guard let viewController = presentingVC else { return }
        self.viewPosition.toggle(on: self.slideIndicativeView)

        switch viewController.viewPresentationStyle() {

        case .custom where estimatedFinalTopOffset == transaltion:
            presentingVCminY = viewController.view.frame.minY
            viewController.view.frame.origin.y = estimatedFinalTopOffset - 15
        case .custom where estimatedInitialTopOffset == transaltion:
            viewController.view.layer.transform = ViewControlerScale.backgroundPopUpScale.transform
            viewController.view.frame.origin.y = presentingVCminY

        case .default where estimatedFinalTopOffset == transaltion:
            presentingVCminY = viewController.view.frame.minY
            presentingVC?.view.frame.origin.y = .zero
        case .default where transaltion == estimatedInitialTopOffset:
            presentingVC?.view.frame.origin.y = presentingVCminY

        case .none where estimatedFinalTopOffset == transaltion:
            viewController.view.layer.transform = ViewControlerScale.backgroundFullScreenScale.transform
        case .none where estimatedInitialTopOffset == transaltion:
            viewController.view.layer.transform = ViewControlerScale.backgroundPopUpScale.transform
        default:
            viewController.view.layer.transform = ViewControlerScale.reset.transform
        }
    }

    /// adds slider bar animation
    func addSliderAnimation() {
        let group = CAAnimationGroup()

        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.slideIndicativeView.layer.position.x,
                                                       y: self.slideIndicativeView.layer.position.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.slideIndicativeView.layer.position.x,
                                                     y: self.slideIndicativeView.layer.position.y - 6))

        let animationForOpactity = CABasicAnimation(keyPath: "opacity")
        animationForOpactity.fromValue = 1
        animationForOpactity.toValue = 0.7

        group.animations = [animation, animationForOpactity]
        group.duration = 0.6
        group.autoreverses = true
        group.repeatCount = 2
        group.speed = 2
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

        self.slideIndicativeView.layer.add(group, forKey: "position")
    }
}

// MARK: Pan helper functions to derive swipe direction
extension UIPanGestureRecognizer {
    enum DraggingState {
        case upwards, downwards, idle
    }

    func dragDirection(inView view: UIView) -> DraggingState {
        let velocity = self.velocity(in: view)
        guard abs(velocity.x) < abs(velocity.y) else { return .idle }
        return velocity.y < 0 ? .upwards : .downwards
    }
}

enum SliderPosition {
    case present
    case dismiss

    mutating func toggle(on view: UIView) {
        switch self {
        case .present:
            view.alpha = 0
            self = .dismiss
        case .dismiss:
            view.alpha = 1
            self = .present
        }
    }
}
