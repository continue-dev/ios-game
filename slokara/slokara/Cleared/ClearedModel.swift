import RxSwift
import RealmSwift

protocol ClearedModelProtocol {
    var task: Observable<Task> { get }
    func fullRecoveryHP()
    func addCoins(coins: Int)
    func addCredits(credits: Int)
    func saveTask(task: Task)
}

final class ClearedModelImpl: ClearedModelProtocol {
    private let mTask: Task
    
    var task: Observable<Task> {
        return Observable.just(self.mTask)
    }
    
    init(taskId: Task) {
        self.mTask = taskId
//        saveTask(task: taskId)
//        guard let realm = try? Realm() else { assert(false, "Realmをインスタンス化できませんでした"); return }
//        guard let status = realm.objects(Task.self).first else { assert(false, "UserStatusを読み込めませんでした"); return }
    }
    
    func fullRecoveryHP() {
        guard let realm = try? Realm() else { assert(false, "Realmをインスタンス化できませんでした"); return }
        guard let status = realm.objects(UserStatus.self).first else { assert(false, "UserStatusを読み込めませんでした"); return }
        try! realm.write {
            status.currentHp = status.maxHp
        }
    }
    
    func addCoins(coins: Int) {
        guard let realm = try? Realm() else { assert(false, "Realmをインスタンス化できませんでした"); return }
        guard let status = realm.objects(UserStatus.self).first else { assert(false, "UserStatusを読み込めませんでした"); return }
        try! realm.write {
            status.numberOfCoins += coins
        }
    }
    
    func addCredits(credits: Int) {
        guard let realm = try? Realm() else { assert(false, "Realmをインスタンス化できませんでした"); return }
        guard let status = realm.objects(UserStatus.self).first else { assert(false, "UserStatusを読み込めませんでした"); return }
        try! realm.write {
            status.numberOfCredit += credits
        }
    }
    
    func saveTask(task: Task) {
        guard let realm = try? Realm() else { assert(false, "Realmをインスタンス化できませんでした"); return }
        guard let status = realm.objects(TaskStatus.self).filter("taskId == \(task.id)").first else { assert(false, "TaskStatusを読み込めませんでした"); return }
        try! realm.write {
            status.isNew = task.isNew
            status.isPassed = task.isPassed
        }
    }
}
