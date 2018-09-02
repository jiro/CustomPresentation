import UIKit

class PresentationController: UIPresentationController {
    private let dimmingView = UIView()

    init(presentedViewController: PresentableViewController, presentingViewController: PresentableViewController) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
    }

    override func presentationTransitionWillBegin() {
        let containerView = self.containerView!

        dimmingView.frame = containerView.bounds
        dimmingView.backgroundColor = .black
        containerView.addSubview(dimmingView)
        containerView.addSubview(presentedViewController.view)
    }
}

extension PresentationController: PresentationAnimatedTransitioning {
    var transitionableViews: [TransitionableViewKey : UIView]? {
        return nil
    }

    func prepareForTransition(using operation: PresentationOperation, targetViews: [TransitionableViewKey : UIView]?) {
        dimmingView.alpha = dimmingViewAlpha(for: operation)
    }

    func transitionAnimators(operation: PresentationOperation, duration: TimeInterval, targetViews: [TransitionableViewKey : UIView]?) -> [UIViewPropertyAnimator] {
        let dimmingAnimator = UIViewPropertyAnimator(duration: duration, curve: operation == .present ? .easeIn : .easeOut) {
            self.dimmingView.alpha = self.dimmingViewAlpha(for: operation)
        }
        return [dimmingAnimator]
    }

    private func dimmingViewAlpha(for operation: PresentationOperation) -> CGFloat {
        return operation == .present ? 0.2 : 0
    }
}

extension PresentationController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationAnimationController(operation: .present)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationAnimationController(operation: .dismiss)
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        let interactionController = PresentationInteractionController(operation: .present)
        let presentingViewController = self.presentingViewController as! PresentationInteractiveTransitioning
        interactionController.wantsInteractiveStart = presentingViewController.interactivePanGestureRecognizer.state == .began
        return interactionController
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        let interactionController = PresentationInteractionController(operation: .dismiss)
        let presentedViewController = self.presentedViewController as! PresentationInteractiveTransitioning
        interactionController.wantsInteractiveStart = presentedViewController.interactivePanGestureRecognizer.state == .began
        return interactionController
    }
}

