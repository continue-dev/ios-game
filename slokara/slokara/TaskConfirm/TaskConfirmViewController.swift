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
        let positive = AlertAction(title: "履修する", style: .positive) { [weak self] in
            #if !PROD
            if UserDefaults.standard.bool(forKey: "tuningMode") {
                guard let tuningViewController = UIStoryboard(name: "TuningStage", bundle: nil).instantiateInitialViewController() as? TuningStageViewController else { return }
                tuningViewController.task = task
                let navigationController = self?.parent as! NavigationViewController
                navigationController.push(tuningViewController, animate: true)
                return
            }
            #endif
            
            guard let battleViewController = UIStoryboard(name: "Battle", bundle: nil).instantiateInitialViewController() as? BattleViewController else { return }
            battleViewController.task = task
            let navigationController = self?.parent as! NavigationViewController
            navigationController.push(battleViewController, animate: true)

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
