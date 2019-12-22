import UIKit

class TaskListViewController: UIViewController, NavigationChildViewController {
    @IBOutlet var topSpacer: UIView!
    @IBOutlet weak var tabView: TaskListTab!
    
    override func viewDidLoad() {
        tabView.setCurrentGrade(.silver)
    }
}
