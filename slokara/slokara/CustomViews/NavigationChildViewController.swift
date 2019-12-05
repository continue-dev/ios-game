import UIKit

protocol NavigationChildViewController where Self: UIViewController {
    var topSpacer: UIView! { get }
    var title: String? { get }
}
