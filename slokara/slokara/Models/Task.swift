import Foundation

struct Task {
    let id: Int
    let name: String
    let targetGrade: Grade
    let targetRank: Int
    let isNew: Bool
    let rewardCredits: Int
    let rewardCoins: Int
    let enemyTypes: [AttributeType]
    var isPassed: Bool
    let stageId: Int
    
    func toTaskStatus(_ isNew: Bool? = nil, _ isPassed: Bool? = nil) -> TaskStatus {
        return TaskStatus(id: self.id, isNew: isNew ?? self.isNew, isPassed: isPassed ?? self.isPassed)
    }
}
