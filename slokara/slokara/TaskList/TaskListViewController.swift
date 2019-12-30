import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController, NavigationChildViewController {
    @IBOutlet var topSpacer: UIView!
    @IBOutlet private weak var tabView: TaskListTab!
    @IBOutlet private weak var taskListTableView: UITableView!
    
    private lazy var viewModel = TaskListViewModel(tabSelected: tabView.tabSelected, cellTaped: taskListTableView.rx.itemSelected)
    private var taskList = [Task]()
    private let dispodeBag = DisposeBag()

    override func viewDidLoad() {
        taskListTableView.register(UINib(nibName: "TaskListCell", bundle: nil), forCellReuseIdentifier: "cell")
        bind()
        setUp()
    }
    
    private func bind() {
        viewModel.currentGrade.bind(to: tabView.bindCurrentGrade).disposed(by: dispodeBag)
        viewModel.taskList
            .bind(to: taskListTableView.rx.items(cellIdentifier: "cell", cellType: TaskListCell.self)) {index, task, cell in
                cell.setTask(task)
        }.disposed(by: dispodeBag)
        
        viewModel.showAlertView
            .bind(to: presentAlert)
            .disposed(by: dispodeBag)
        
        taskListTableView.rx.didScroll.subscribe({ [unowned self] _ in
            guard let indicator = self.taskListTableView.subviews.last else { return }
            indicator.backgroundColor = UIColor(red: 61.0 / 255, green: 144.0 / 255, blue: 1, alpha: 1)
            }).disposed(by: dispodeBag)
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
        tabView.switchPrevTab()
    }
    
    @objc private func swipeToLeft(_ sender: Any) {
        tabView.switchNextTab()
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
