import UIKit

class ClearedViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet private weak var taskCellView: TaskCellView!
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let task = self.task {
            self.taskCellView.setTask(task)
        }
    }
}
