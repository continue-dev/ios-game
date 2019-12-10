import UIKit

protocol NavigationChildViewController where Self: UIViewController {
    var topSpacer: UIView! { get }
}

extension NavigationChildViewController where Self: UIViewController {
    func applyTopSpacer(frame: CGRect) {
        topSpacer.translatesAutoresizingMaskIntoConstraints = true
        topSpacer.frame = frame
    }
}
