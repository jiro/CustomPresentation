import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var outLabel: UILabel!

    private let tapGestureRecognizer = UITapGestureRecognizer()
    private let panGestureRecognizer = UIPanGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestureRecognizer.addTarget(self, action: #selector(handleTap(_:)))
        panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        controlView.addGestureRecognizer(tapGestureRecognizer)
        controlView.addGestureRecognizer(panGestureRecognizer)

        controlView.layer.shadowColor = UIColor.black.cgColor
        controlView.layer.shadowOpacity = 0.17
        controlView.layer.shadowRadius = 16
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        presentSecondViewController()
    }

    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            presentSecondViewController()
        }
    }

    private func presentSecondViewController() {
        let secondViewController = self.secondViewController
        let presentationController = PresentationController(presentedViewController: secondViewController, presentingViewController: self)
        secondViewController.transitioningDelegate = presentationController
        present(secondViewController, animated: true)
    }

    private var secondViewController: SecondViewController {
        return storyboard!.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
    }
}

extension FirstViewController: PresentationAnimatedTransitioning {
    var transitionableViews: [TransitionableViewKey : UIView]? {
        return [.controlView: controlView, .outLabel: outLabel]
    }

    func prepareForTransition(using operation: PresentationOperation, targetViews: [TransitionableViewKey : UIView]?) {
    }

    func transitionAnimators(operation: PresentationOperation, duration: TimeInterval, targetViews: [TransitionableViewKey : UIView]?) -> [UIViewPropertyAnimator] {
        return []
    }
}

extension FirstViewController: PresentationInteractiveTransitioning {
    var interactivePanGestureRecognizer: UIPanGestureRecognizer {
        return panGestureRecognizer
    }
}
