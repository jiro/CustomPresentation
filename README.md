# CustomPresentation

This application demonstrates a custom presentation that coordinates between multiple animations using [UIViewPropertyAnimator](https://developer.apple.com/documentation/uikit/uiviewpropertyanimator) and [view controller transition APIs](https://developer.apple.com/documentation/uikit/animation_and_haptics/view_controller_transitions). 

The idea of coordinating multiple animations was explained in the [_Advance Animation with UIKit_ WWDC 2017 session 230](https://developer.apple.com/videos/play/wwdc2017/230/). This application is implemented by referring to that approach. 

## Demo

![demo](demo.gif)

## Overview

### Controllers

#### [PresentationController](https://github.com/hedjirog/CustomPresentation/blob/master/CustomPresentation/Presentation/PresentationController.swift)


- Manages the presentation style
- Adds custom views for presentaion
- Inherits from `UIPresentationController`
- Conforms to the `UIViewControllerTransitioningDelegate` protocol


#### [PresentationAnimationController](https://github.com/hedjirog/CustomPresentation/blob/master/CustomPresentation/Presentation/PresentationAnimationController.swift)

- Is responsible for creating the animations
- Conforms to the `UIViewControllerAnimatedTransitioning` protocol

#### [PresentationInteractionController](https://github.com/hedjirog/CustomPresentation/blob/master/CustomPresentation/Presentation/PresentationInteractionController.swift)

- Drives the timing of custom animations using gesture recognizers
- Inherits from `UIPercentDrivenInteractiveTransition`
- Conforms to the `UIViewControllerInteractiveTransitioning` protocol

### Animations

All transition animations are defined with `transitionAnimators` method of `PresentationAnimatedTransitioning` protocol.
You can refer to the implementation of [SecondViewController](https://github.com/hedjirog/CustomPresentation/blob/master/CustomPresentation/SecondViewController.swift).

## Author

Jiro [@hedjirog](https://twitter.com/hedjirog)

## License

CustomPresentation is available under the MIT license. See the LICENSE file for more info.
