import Foundation
import RealmSwift

class TaskStatus: Object {
    @objc dynamic var taskId: Int
    @objc dynamic var isNew: Bool
    @objc dynamic var isPassed: Bool
    
    override static func primaryKey() -> String? {
        return "taskId"
    }
    
    init(id: Int, isNew: Bool, isPassed: Bool) {
        self.taskId = id
        self.isNew = isNew
        self.isPassed = isPassed
    }
    
    required override init() {
        self.taskId = 0
        self.isNew = true
        self.isPassed = false
    }
}
