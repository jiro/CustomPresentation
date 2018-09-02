import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var inLabel: UILabel!
    @IBOutlet weak var outLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    private let panGestureRecognizer = UIPanGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        controlView.addGestureRecognizer(panGestureRecognizer)

        controlView.layer.shadowColor = UIColor.black.cgColor
        controlView.layer.shadowOpacity = 0.17
        controlView.layer.shadowRadius = 16
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        controlView.layer.shadowColor = UIColor.clear.cgColor
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        controlView.layer.shadowColor = UIColor.black.cgColor
    }

    @objc private func handleTap(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            dismiss(animated: true)
        }
    }
}

extension SecondViewController: PresentationAnimatedTransitioning {
    var transitionableViews: [TransitionableViewKey : UIView]? {
        return [.controlView: controlView, .outLabel: outLabel, .inLabel: inLabel]
    }

    func prepareForTransition(using operation: PresentationOperation, targetViews: [TransitionableViewKey : UIView]?) {
        view.layoutIfNeeded()

        controlView.transform = controlViewTransform(for: operation, targetViews: targetViews)
        inLabel.transform = outLabelTransform(for: operation, targetViews: targetViews)
        outLabel.transform = inLabelTransform(for: operation, targetViews: targetViews)

        controlView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        controlView.layer.cornerRadius = controlViewCornerRadius(for: operation)

        inLabel.alpha = outLabelAlpha(for: operation)
        outLabel.alpha = inLabelAlpha(for: operation)

        closeButton.alpha = closeButtonAlpha(for: operation)
    }

    func transitionAnimators(operation: PresentationOperation, duration: TimeInterval, targetViews: [TransitionableViewKey : UIView]?) -> [UIViewPropertyAnimator] {
        let transformAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            self.controlView.transform = self.controlViewTransform(for: operation, targetViews: targetViews)
            self.inLabel.transform = self.outLabelTransform(for: operation, targetViews: targetViews)
            self.outLabel.transform = self.inLabelTransform(for: operation, targetViews: targetViews)
        }

        let cornerAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            self.controlView.layer.cornerRadius = self.controlViewCornerRadius(for: operation)
        }

        let inLabelAnimator = UIViewPropertyAnimator(duration: duration, curve: operation == .present ? .easeIn : .easeOut) {
            self.inLabel.alpha = self.outLabelAlpha(for: operation)
        }
        let outLabelAnimator = UIViewPropertyAnimator(duration: duration, curve: operation == .present ? .easeOut : .easeIn) {
            self.outLabel.alpha = self.inLabelAlpha(for: operation)
        }
        inLabelAnimator.scrubsLinearly = false
        outLabelAnimator.scrubsLinearly = false

        let closeButtonAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            Keyframe.makeKeyframes {
                Keyframe.closeButton.add(for: operation) {
                    self.closeButton.alpha = self.closeButtonAlpha(for: operation)
                }
            }
        }

        return [transformAnimator, cornerAnimator, inLabelAnimator, outLabelAnimator, closeButtonAnimator]
    }

    private func controlViewTransform(for operation: PresentationOperation, targetViews: [TransitionableViewKey : UIView]?) -> CGAffineTransform {
        switch operation {
        case .present:
            return .identity
        case .dismiss:
            guard let targetView = targetViews?[.controlView] else { return .identity }
            return CGAffineTransform(translationX: 0, y: targetView.frame.minY - controlView.frame.minY)
        }
    }

    private func outLabelTransform(for operation: PresentationOperation, targetViews: [TransitionableViewKey : UIView]?) -> CGAffineTransform {
        switch operation {
        case .present:
            return .identity
        case .dismiss:
            guard let targetView = targetViews?[.outLabel] else { return .identity }
            let scale = CGAffineTransform(scaleX: targetView.frame.width / inLabel.frame.width, y: targetView.frame.height / inLabel.frame.height)
            let translation = CGAffineTransform(translationX: 0, y: targetView.frame.minY - inLabel.frame.minY + (targetView.frame.height - inLabel.frame.height) / 2)
            return scale.concatenating(translation)
        }
    }

    private func inLabelTransform(for operation: PresentationOperation, targetViews: [TransitionableViewKey : UIView]?) -> CGAffineTransform {
        switch operation {
        case .present:
            guard let targetView = targetViews?[.inLabel] else { return .identity }
            let scale = CGAffineTransform(scaleX: targetView.frame.width / outLabel.frame.width, y: targetView.frame.height / outLabel.frame.height)
            let translation = CGAffineTransform(translationX: 0, y: targetView.frame.minY - outLabel.frame.minY + (targetView.frame.height - outLabel.frame.height) / 2)
            return scale.concatenating(translation)
        case .dismiss:
            return .identity
        }
    }

    private func controlViewCornerRadius(for operation: PresentationOperation) -> CGFloat {
        return operation == .present ? 12 : 0
    }

    private func outLabelAlpha(for operation: PresentationOperation) -> CGFloat {
        return operation == .present ? 1 : 0
    }

    private func inLabelAlpha(for operation: PresentationOperation) -> CGFloat {
        return operation == .present ? 0 : 1
    }

    private func closeButtonAlpha(for operation: PresentationOperation) -> CGFloat {
        return operation == .present ? 1 : 0
    }

    private enum Keyframe: PresentationKeyframe {
        case closeButton

        func startTime(for operation: PresentationOperation) -> Double {
            switch self {
            case .closeButton:
                return operation == .present ? 1 - relativeDuration : 0
            }
        }

        var relativeDuration: Double {
            switch self {
            case .closeButton:
                return 0.5
            }
        }
    }
}

extension SecondViewController: PresentationInteractiveTransitioning {
    var interactivePanGestureRecognizer: UIPanGestureRecognizer {
        return panGestureRecognizer
    }
}
