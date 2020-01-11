import UIKit

class TaskConfirmViewController: UIViewController, NavigationChildViewController {
    @IBOutlet var topSpacer: UIView!
    @IBOutlet private weak var taskCellView: TaskCellView!
    @IBOutlet private weak var alertView: AlertView!
    
    private var selectedTask: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        guard let task = selectedTask else { return }
        taskCellView.setTask(task)
        alertView.setMessage("この課題を履修しますか？")
        let positive = AlertAction(title: "履修する", style: .positive) {
            // TODO: ボタン選択時の画面遷移
        }
        let negative = AlertAction(title: "やめる", style: .negative) { [weak self] in
            let navigation = self?.parent as? NavigationViewController
            navigation?.popViewController(animate: true)
        }
        alertView.addAction(action: positive)
        alertView.addAction(action: negative)
    }
    
    func setTask(_ task: Task) {
        self.selectedTask = task
    }
}
