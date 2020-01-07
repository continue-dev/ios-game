import RxSwift

protocol TaskListModelProtocol {
    var currentGrade: Observable<Grade> { get }
    var taskList: Observable<[Task]> { get }
    func filterByGrade(_ grades: [Grade])
}

final class TaskListModelImpl: TaskListModelProtocol {
    private lazy var tasks = BehaviorSubject<[Task]>(value: getTasks())
    var currentGrade: Observable<Grade> {
        return Observable.just(.gold)
    }
    
    var taskList: Observable<[Task]> {
        return tasks
    }
    
    func filterByGrade(_ grades: [Grade]) {
        let filterdTask = getTasks().filter { grades.contains($0.targetGrade) }
        self.tasks.onNext(filterdTask)
    }
}

// TODO: 正規実装後に削除
extension TaskListModelImpl {
    func getTasks() -> [Task] {
        [
            Task(id: 0, name: "サンプル１", targetGrade: .wood, targetRank: 1, isNew: true, rewardCredits: 1, rewardCoins: 10, enemyTypes: [.fire], isPassed: false),
            Task(id: 1, name: "サンプル２", targetGrade: .stone, targetRank: 2, isNew: false, rewardCredits: 2, rewardCoins: 20, enemyTypes: [.water, .light], isPassed: true),
            Task(id: 2, name: "長いタイトルの場合は２行で表示する事", targetGrade: .copper, targetRank: 3, isNew: true, rewardCredits: 3, rewardCoins: 30, enemyTypes: [.fire, .wind, .light], isPassed: false),
            Task(id: 3, name: "さらに長いタイトルの場合は２行で表示した上でさらに文字サイズを縮小して表示する事で３行以上にならないように対応する事", targetGrade: .silver, targetRank: 4, isNew: false, rewardCredits: 4, rewardCoins: 40, enemyTypes: [.fire, .wind, .soil, .darkness], isPassed: true),
            Task(id: 4, name: "サンプル５", targetGrade: .gold, targetRank: 5, isNew: true, rewardCredits: 11, rewardCoins: 1111, enemyTypes: [.fire, .water, .wind, .soil, .light], isPassed: false),
            Task(id: 0, name: "サンプル１", targetGrade: .wood, targetRank: 1, isNew: true, rewardCredits: 1, rewardCoins: 10, enemyTypes: [.fire, .water, .wind, .soil, .light, .darkness], isPassed: false),
            Task(id: 1, name: "サンプル２", targetGrade: .stone, targetRank: 2, isNew: false, rewardCredits: 2, rewardCoins: 20, enemyTypes: [.water, .light], isPassed: true),
            Task(id: 2, name: "サンプル３", targetGrade: .copper, targetRank: 3, isNew: true, rewardCredits: 3, rewardCoins: 30, enemyTypes: [.wind], isPassed: false),
            Task(id: 3, name: "サンプル４", targetGrade: .silver, targetRank: 4, isNew: false, rewardCredits: 4, rewardCoins: 40, enemyTypes: [.soil, .darkness], isPassed: true),
            Task(id: 4, name: "サンプル５", targetGrade: .gold, targetRank: 5, isNew: true, rewardCredits: 11, rewardCoins: 1111, enemyTypes: [.fire, .wind, .light], isPassed: false)
        ]
    }
}
