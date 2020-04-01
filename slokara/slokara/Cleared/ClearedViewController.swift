import UIKit

class ClearedViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet private weak var taskCellView: TaskCellView!
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.parent as? NavigationViewController)?.backButtonIsHidden(true)
        if let task = self.task {
            self.taskCellView.setTask(task)
        }
    }
}
