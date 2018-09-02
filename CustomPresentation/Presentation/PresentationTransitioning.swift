import UIKit

enum TransitionableViewKey {
    case controlView
    case inLabel
    case outLabel
}

protocol PresentationAnimatedTransitioning {
    var transitionableViews: [TransitionableViewKey : UIView]? { get }
    func prepareForTransition(using operation: PresentationOperation, targetViews: [TransitionableViewKey : UIView]?)
    func transitionAnimators(operation: PresentationOperation, duration: TimeInterval, targetViews: [TransitionableViewKey : UIView]?) -> [UIViewPropertyAnimator]
}

protocol PresentationInteractiveTransitioning {
    var interactivePanGestureRecognizer: UIPanGestureRecognizer { get }
}

typealias PresentableViewController = UIViewController & PresentationAnimatedTransitioning & PresentationInteractiveTransitioning
