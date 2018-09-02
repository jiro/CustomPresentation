import UIKit

protocol PresentationKeyframe {
    func startTime(for operation: PresentationOperation) -> Double
    var relativeDuration: Double { get }
}

extension PresentationKeyframe {
    static func makeKeyframes(_ animations: @escaping () -> Void) {
        UIView.animateKeyframes(withDuration: 0, delay: 0, animations: animations)
    }

    func add(for operation: PresentationOperation, animations: @escaping () -> Void) {
        UIView.addKeyframe(withRelativeStartTime: startTime(for: operation),
                           relativeDuration: relativeDuration,
                           animations: animations)
    }
}
