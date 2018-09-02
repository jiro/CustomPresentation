import UIKit

class PresentationInteractionController: UIPercentDrivenInteractiveTransition {
    private let operation: PresentationOperation
    private var interactiveAreaHeight: CGFloat?

    init(operation: PresentationOperation) {
        self.operation = operation
        super.init()
    }

    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        prepareForInteraction(using: transitionContext)
        super.startInteractiveTransition(transitionContext)
    }

    private func prepareForInteraction(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = self.fromViewController(for: transitionContext)
        let toViewController = self.toViewController(for: transitionContext)

        let fromInteractiveView = fromViewController.interactivePanGestureRecognizer.view!
        let toInteractiveView = toViewController.interactivePanGestureRecognizer.view!

        let fromTargetMinY = fromInteractiveView.frame.minY - fromInteractiveView.transform.ty
        let toTargetMinY = toInteractiveView.frame.minY - toInteractiveView.transform.ty

        interactiveAreaHeight = abs(fromTargetMinY - toTargetMinY)

        [fromViewController, toViewController].forEach {
            $0.interactivePanGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        }
    }

    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            pause()
        case .changed:
            update(percentComplete(for: gestureRecognizer))
            gestureRecognizer.setTranslation(.zero, in: nil)
        case .ended, .cancelled:
            if percentComplete > 0.5 {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }

    private func percentComplete(for gestureRecognizer: UIPanGestureRecognizer) -> CGFloat {
        return percentComplete + (operation == .present ? -1.0 : 1.0) * gestureRecognizer.translation(in: nil).y / interactiveAreaHeight!
    }

    private func fromViewController(for transitionContext: UIViewControllerContextTransitioning) -> PresentationInteractiveTransitioning {
        return transitionContext.viewController(forKey: .from) as! PresentationInteractiveTransitioning
    }

    private func toViewController(for transitionContext: UIViewControllerContextTransitioning) -> PresentationInteractiveTransitioning {
        return transitionContext.viewController(forKey: .to) as! PresentationInteractiveTransitioning
    }
}
