import Foundation

enum PresentationOperation {
    case present
    case dismiss

    var duration: TimeInterval { return 0.6 }
}
