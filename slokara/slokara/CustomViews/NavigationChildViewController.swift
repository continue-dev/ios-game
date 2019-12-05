import UIKit

protocol NavigationChildViewController where Self: UIViewController {
    var topSpacer: UIView! { get }
    var title: String? { get }
}

extension NavigationChildViewController where Self: UIViewController {
    func applyTopSpacer(frame: CGRect) {
        topSpacer.translatesAutoresizingMaskIntoConstraints = true
        topSpacer.frame = frame
    }
}
