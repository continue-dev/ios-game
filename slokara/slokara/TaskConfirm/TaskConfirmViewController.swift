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
//            let navigation = self?.parent as? NavigationViewController
//            navigation?.popViewController(animate: true)

            
//            let navigation = self?.parent as? NavigationBattleViewController
//            navigation?.popViewController(animate: true)
            
//            navigation?.push(taskListVC, animate: true)
            let navigation2 = self?.parent as? NavigationViewController
            let homeVC = UIStoryboard(name: "Battle", bundle: nil).instantiateInitialViewController() as! BattleViewController
            homeVC.title = "Battle"//self?.title
            
            navigation2?.push(homeVC, animate: true)
//            let current = currentViewController
//            self?.children.last.append(homeVC)
//
//            addChild(viewController)
//            viewController.view.frame = self.container.frame
//            self.container.addSubview(viewController.view)
            
//            self!.transition(from: navigation2,
//                           to: homeVC,
//                           duration: 0.3,
//                           options: .transitionCrossDissolve,
//                           animations: nil) { [weak self] _ in
//                    homeVC.didMove(toParent: self)
//                }
            
//            let topFrame = CGRect(x: 0, y: 0, width: topSpacer.bounds.width, height: topSpacer.bounds.height)
//            viewController.applyTopSpacer(frame: topFrame)

            
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
