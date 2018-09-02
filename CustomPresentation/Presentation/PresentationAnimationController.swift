import UIKit

class PresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let operation: PresentationOperation
    private var transitionAnimator: CoordinatedAnimator?

    init(operation: PresentationOperation) {
        self.operation = operation
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return operation.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        interruptibleAnimator(using: transitionContext).startAnimation()
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if let transitionAnimator = transitionAnimator {
            return transitionAnimator
        }

        prepareForTransitionIfNeeded(using: transitionContext)

        let fromViewController = self.fromViewController(for: transitionContext)
        let toViewController = self.toViewController(for: transitionContext)
        let presentationController = self.presentationController(for: transitionContext)

        var animators: [UIViewPropertyAnimator] = []
        [fromViewController, toViewController, presentationController].forEach {
            animators += $0.transitionAnimators(operation: operation,
                                                duration: transitionDuration(using: transitionContext),
                                                targetViews: toViewController.transitionableViews)
        }

        let prioritizedAnimators = self.prioritizedAnimators(from: animators)
        let animator = CoordinatedAnimator(primaryAnimator: prioritizedAnimators.primary, secondaryAnimators: prioritizedAnimators.secondary)
        animator.addCompletion { position in
            let didComplete = position == .end
            transitionContext.completeTransition(didComplete)
        }
        transitionAnimator = animator
        return animator
    }

    private func prepareForTransitionIfNeeded(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = self.fromViewController(for: transitionContext)
        let toViewController = self.toViewController(for: transitionContext)
        let presentationController = self.presentationController(for: transitionContext)

        if operation == .present {
            toViewController.prepareForTransition(using: .dismiss, targetViews: fromViewController.transitionableViews)
            presentationController.prepareForTransition(using: .dismiss, targetViews: fromViewController.transitionableViews)
        }
    }

    private func prioritizedAnimators(from animators: [UIViewPropertyAnimator]) -> (primary: UIViewPropertyAnimator, secondary: [UIViewPropertyAnimator]) {
        var animators = ArraySlice(animators)
        let primary = animators.popFirst()!
        let secondary = Array(animators)
        return (primary, secondary)
    }

    func animationEnded(_ transitionCompleted: Bool) {
        transitionAnimator = nil
    }

    private func fromViewController(for transitionContext: UIViewControllerContextTransitioning) -> PresentationAnimatedTransitioning {
        return transitionContext.viewController(forKey: .from) as! PresentationAnimatedTransitioning
    }

    private func toViewController(for transitionContext: UIViewControllerContextTransitioning) -> PresentationAnimatedTransitioning {
        return transitionContext.viewController(forKey: .to) as! PresentationAnimatedTransitioning
    }

    private func presentationController(for transitionContext: UIViewControllerContextTransitioning) -> PresentationAnimatedTransitioning {
        let viewController = transitionContext.viewController(forKey: operation == .present ? .to : .from)!
        return viewController.presentationController as! PresentationAnimatedTransitioning
    }
}
