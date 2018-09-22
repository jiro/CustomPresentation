import UIKit

class ViewPropertyAnimatorGroup: NSObject, UIViewImplicitlyAnimating {
    private let timingAnimator: UIViewPropertyAnimator
    private var animators: [UIViewPropertyAnimator]

    init(duration: TimeInterval, timingParameters: UITimingCurveProvider, animators: [UIViewPropertyAnimator]) {
        self.timingAnimator = UIViewPropertyAnimator(duration: duration, timingParameters: timingParameters)
        self.animators = [timingAnimator] + animators
        super.init()
        setupTimingAnimator()
    }

    private func setupTimingAnimator() {
        // Specifies a simple animation since UIViewPropertyAnimator completes immediately if animatable properties do not exist.
        let view = UIView()
        UIApplication.shared.keyWindow?.addSubview(view)
        timingAnimator.addAnimations { view.alpha = 0 }
        timingAnimator.addCompletion { _ in view.removeFromSuperview() }
    }

    func addCompletion(_ completion: @escaping (UIViewAnimatingPosition) -> Void) {
        timingAnimator.addCompletion(completion)
    }

    var state: UIViewAnimatingState {
        return timingAnimator.state
    }

    var isRunning: Bool {
        return timingAnimator.isRunning
    }

    var isReversed: Bool {
        get {
            return timingAnimator.isReversed
        }
        set(isReversed) {
            animators.forEach { $0.isReversed = isReversed }
        }
    }

    var fractionComplete: CGFloat {
        get {
            return timingAnimator.fractionComplete
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
}
