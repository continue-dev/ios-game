import RxSwift
import RxCocoa

final class TaskListViewModel {
    private let taskListModel: TaskListModelProtocol
    private let disposeBag = DisposeBag()
    private var tasks = [Task]() {
        didSet {
            taskList.accept(tasks)
        }
    }
    
    let taskList = BehaviorRelay<[Task]>(value: [])
    let currentGrade = BehaviorRelay<Grade>(value: .wood)
    var showAlertView: Observable<Task>!
    
    init(tabSelected: Observable<TaskListTab.TabKind>, cellTaped: ControlEvent<IndexPath>, taskListModel: TaskListModelProtocol = TaskListModelImpl()) {
        self.taskListModel = taskListModel
        
        self.taskListModel.currentGrade.subscribe(onNext: { [weak self] grade in
            self?.currentGrade.accept(grade)
            }).disposed(by: disposeBag)
        self.taskListModel.taskList.subscribe(onNext: { [weak self] tasks in
            self?.tasks = tasks
            }).disposed(by: disposeBag)
        
        self.showAlertView = cellTaped.asObservable().map{ [unowned self] in self.tasks[$0.row] }
        tabSelected.subscribe({ [weak self] tabKind in
            self?.taskListModel.filterByGrade(tabKind.element!.toGrade)
            }).disposed(by: disposeBag)
    }
}
