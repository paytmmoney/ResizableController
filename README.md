
## Overview

**ResizableController** is the custom model presentation style written in swift.


| Dark Mode | Light Mode |
|:----------|:-----|
|![BasicFlow](https://user-images.githubusercontent.com/74349937/99520326-fa993d00-29b8-11eb-85cb-b91abbbb81a7.gif)|![DismissFlow_light](https://user-images.githubusercontent.com/74349937/99521441-6def7e80-29ba-11eb-8caf-cd15ffced50e.gif)|
|![OnTopOfModelPresentation](https://user-images.githubusercontent.com/74349937/99520487-2c120880-29b9-11eb-9208-540650c6ae1e.gif)|![OnModelPresentation](https://user-images.githubusercontent.com/74349937/99521540-8a8bb680-29ba-11eb-8c77-cae890a65f21.gif)|


## Features

- [X] Resizable View Controller with **custom initial/final height.**
- [X] Works on all screens and devices supporting **iOS 11.0+**
- [X] Provides Backward compatibility of iOS 13's automatic presentation style to lower versions.
- [X] 100% compatible with other presentation styles.
- [X] Simple to Integrate, merely couple of lines of code.
- [X] Slick transition animations.
- [X] Dedicated Callbacks when view controller size changes.
- [X] Controller can be dismissed via swipe down and background tap.
- [X] Light and Dark mode compatible.

## Installation
This version is Swift 5 compatible.

### CocoaPods

ResizableController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ResizableController', '~> 1.0'
```

### Swift Package Manager

ResizableController is available through [Swift Package Manager](https://swift.org/package-manager/). To install
it, add package dependency from Url:

```swift
https://github.com/paytmmoney/ResizableController
```

## Usage
### ResizableControllerPositionHandler
View Controller to be presented, using resizable transition,  needs to conform to protocol  `ResizableControllerPositionHandler`. This protocol inherits UIViewController at implementattion level.

```swift
public protocol ResizableControllerPositionHandler: UIViewController {
    var shouldShowSlideUpIndication: Bool { get }
    var sliderBackgroundColor: UIColor { get }

    var initialTopOffset: CGFloat { get }
    var finalTopOffset: CGFloat { get }

    func willMoveTopOffset(value: CGFloat)
    func didMoveTopOffset(value: CGFloat)
}
```
All the above properties are optional and can be added to achive different result.

### shouldShowSlideUpIndication:

Override this property if you do not want to include intuitive slide up indicator. Disabled by default for non-resizable views controllers.

### sliderBackgroundColor:

Override this property to give differnent colour to Slider up indicator. Defaults to darkGrey with alpha 0.5

### initialTopOffset:

Override this property to give initial custom height, calculated from top.

Suggestion: Think about this offset as a topAnchor constraint we apply to a view.

### finalTopOffset:

Override this property to give custom final height, calculated from top. Resizable controller will change its height from initialTopOffset to finalTopOffset.

### willMoveTopOffset:

Override this property to add behaviours to view controller before it changes it size.
If you override this property, make sure you dismiss view controller manually as default behaviur will be overridden.

### didMoveTopOffset:
Similar to willMoveTopOffset, but will trigger when animation is complete and view controller is resized.


## Example

## Rezisable View Controller

For creating a resizable controller.  Conform to `ResizableControllerPositionHandler` and override `initialTopOffset`. 

```swift
import ResizableController

class ResizablePresentedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ResizablePresentedViewController: ResizableControllerPositionHandler {
// This height 500 is from topAnchor
    var initialTopOffset: CGFloat {
        500
    }
}
```

## Fixed Height View Controller

For creating a fixed height controller.  Conform to `ResizableControllerPositionHandler` and override `initialTopOffset` &  `finalTopOffset`. 

```swift
import ResizableController

class FixedHeightPresentedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FixedHeightPresentedViewController: ResizableControllerPositionHandler {
// This height 500 is from topAnchor
    var initialTopOffset: CGFloat {
        500
    }
    
// Both initial and final height should be same to make it a fixed height controller
    var finalTopOffset: CGFloat {
        500
    }
}
```

or:

Do not override any property, this will give you iOS 13's automatic presentation, which can be used with lower iOS versions.

```swift
import ResizableController

class FixedHeightPresentedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ResizablePresentedViewController: ResizableControllerPositionHandler {}
```

## How to modally Present

To present, call this below overload method

```swift
func present(_ viewControllerToPresent: ResizableControllerPositionHandler,
             animationDuration: TimeInterval = 0.3,
             completion: (() -> Void)? = nil)
```
Example:

```swift
let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ResizablePresentedViewController") as ResizablePresentedViewController
self.present(viewController)
```

# Author


**Arjun Baru**, iOS Engineer at Paytmoney Ltd, [paytmmoney.com](https://www.paytmmoney.com/)<br>
You can reach out to me at **arjun.baru@paytmmoney.com**

In collaboration with:

[Shahrukh Alam](https://github.com/shahrukh-alam) & [Rahul Mathur](https://github.com/PaytmMoneyOpenSource)


# License

ResizableController is available under the MIT license. See the LICENSE file for more info.

## Sample Project

Here is the sample project implementing ResizableController [Sample Project](https://github.com/paytmmoney/ResizableController/tree/main)


## Suggestions or feedback?

Feel free to create a pull request, open an issue or find [us on Twitter](https://twitter.com/PaytmMoney).

