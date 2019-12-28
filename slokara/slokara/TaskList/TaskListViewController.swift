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
    }
}

extension TaskListViewController {
    private var presentAlert: Binder<Task> {
        return Binder(self) { me, task in
            let navigation = self.parent as! NavigationViewController
            let taskListVC = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! NavigationChildViewController
            taskListVC.title = task.name
            navigation.push(taskListVC, animate: true)
        }
    }
}
