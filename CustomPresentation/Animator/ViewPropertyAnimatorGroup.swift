import UIKit

class ViewPropertyAnimatorGroup: NSObject, UIViewImplicitlyAnimating {
    private let primaryAnimator: UIViewPropertyAnimator
    private var animators: [UIViewPropertyAnimator]

    init(primaryAnimator: UIViewPropertyAnimator, secondaryAnimators: [UIViewPropertyAnimator]) {
        self.primaryAnimator = primaryAnimator
        self.animators = [primaryAnimator] + secondaryAnimators
    }

    func addCompletion(_ completion: @escaping (UIViewAnimatingPosition) -> Void) {
        primaryAnimator.addCompletion(completion)
    }

    var state: UIViewAnimatingState {
        return primaryAnimator.state
    }

    var isRunning: Bool {
        return primaryAnimator.isRunning
    }

    var isReversed: Bool {
        get {
            return primaryAnimator.isReversed
        }
        set(isReversed) {
            animators.forEach { $0.isReversed = isReversed }
        }
    }

    var fractionComplete: CGFloat {
        get {
            return primaryAnimator.fractionComplete
        }
        set(fractionComplete) {
            animators.forEach { $0.fractionComplete = fractionComplete }
        }
    }

    func startAnimation() {
        animators.forEach { $0.startAnimation() }
    }

    func startAnimation(afterDelay delay: TimeInterval) {
        animators.forEach { $0.startAnimation(afterDelay: delay) }
    }

    func pauseAnimation() {
        animators.forEach { $0.pauseAnimation() }
    }

    func stopAnimation(_ withoutFinishing: Bool) {
        animators.forEach { $0.stopAnimation(withoutFinishing) }
    }

    func finishAnimation(at finalPosition: UIViewAnimatingPosition) {
        animators.forEach { $0.finishAnimation(at: finalPosition) }
    }

    func continueAnimation(withTimingParameters parameters: UITimingCurveProvider?, durationFactor: CGFloat) {
        animators.forEach {
            $0.continueAnimation(withTimingParameters: parameters, durationFactor: durationFactor)
        }
    }
}
