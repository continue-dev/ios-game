import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController, NavigationChildViewController {
    @IBOutlet var topSpacer: UIView!
    @IBOutlet private weak var tabView: TaskListTab!
    @IBOutlet private weak var taskListTableView: UITableView!
    
    private lazy var viewModel = TaskListViewModel(tabSelected: tabView.tabSelected, cellTaped: taskListTableView.rx.itemSelected)
    private var taskList = [Task]()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        taskListTableView.register(UINib(nibName: "TaskListCell", bundle: nil), forCellReuseIdentifier: "cell")
        bind()
        setUp()
    }
    
    private func bind() {
        viewModel.currentGrade.bind(to: tabView.bindCurrentGrade).disposed(by: disposeBag)
        viewModel.taskList
            .bind(to: taskListTableView.rx.items(cellIdentifier: "cell", cellType: TaskListCell.self)) {index, task, cell in
                cell.setTask(task)
        }.disposed(by: disposeBag)
        
        viewModel.showAlertView
            .bind(to: presentAlert)
            .disposed(by: disposeBag)
        
        taskListTableView.rx.didScroll.subscribe({ [unowned self] _ in
            guard let indicator = self.taskListTableView.subviews.last else { return }
            indicator.backgroundColor = UIColor(red: 61.0 / 255, green: 144.0 / 255, blue: 1, alpha: 1)
            }).disposed(by: disposeBag)
    }
    
    private func setUp() {
        let swipeGestureToRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeToRight(_:)))
        swipeGestureToRight.direction = .right
        let swipeGestureToLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeToLeft(_:)))
        swipeGestureToLeft.direction = .left
        taskListTableView.addGestureRecognizer(swipeGestureToRight)
        taskListTableView.addGestureRecognizer(swipeGestureToLeft)
    }
    
    @objc private func swipeToRight(_ sender: Any) {
        guard tabView.canBackPrev() else { return }
        taskListTableView.layer.add(switchTabTransition(from: .fromLeft), forKey: nil)
        tabView.switchPrevTab()
    }
    
    @objc private func swipeToLeft(_ sender: Any) {
        guard tabView.canGoNext() else { return }
        taskListTableView.layer.add(switchTabTransition(from: .fromRight), forKey: nil)
        tabView.switchNextTab()
    }
    
    private func switchTabTransition(from: CATransitionSubtype) -> CATransition {
        let transition:CATransition = CATransition()
        transition.startProgress = 0
        transition.endProgress = 1.0
        transition.type = .push
        transition.subtype = from
        transition.duration = 0.2
        return transition
    }
}

extension TaskListViewController {
    private var presentAlert: Binder<Task> {
        return Binder(self) { me, task in
            let navigation = me.parent as! NavigationViewController
            let taskConfirmVC = UIStoryboard(name: "TaskConfirm", bundle: nil).instantiateInitialViewController() as! TaskConfirmViewController
            taskConfirmVC.title = me.title
            taskConfirmVC.setTask(task)
            navigation.push(taskConfirmVC, animate: true)
        }
    }
}
