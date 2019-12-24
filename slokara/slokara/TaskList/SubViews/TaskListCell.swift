import UIKit

class TaskListCell: UITableViewCell {
    
    @IBOutlet private weak var taskNameLable: CommonFontLabel!
    @IBOutlet private weak var enemyTypeView: UIStackView!
    @IBOutlet private weak var emblemImageView: UIImageView!
    @IBOutlet private weak var coinLabel: CommonFontLabel!
    @IBOutlet private weak var newLabel: BorderedLabel!
    @IBOutlet private weak var creditLabel: CommonFontLabel!
    @IBOutlet private weak var rankLabel: BorderedLabel!
    @IBOutlet private weak var passedStampImageView: UIImageView!
    
    func setTask(_ task: Task) {
        taskNameLable.text = task.name
        emblemImageView.image = task.targetGrade.emblemImage
        rankLabel.text = "\(task.targetRank)"
        rankLabel.strokeColor = task.targetGrade.textBorderColor
        creditLabel.text = "\(task.rewardCredits)"
        coinLabel.text = "\(task.rewardCoins)"
        newLabel.isHidden = !task.isNew
        passedStampImageView.isHidden = !task.isPassed
        enemyTypeView.subviews.enumerated().forEach { offset, view in
            guard let enemyType = view as? UIImageView else { return }
            guard task.enemyTypes.count > offset else {
                enemyType.image = nil
                enemyType.alpha = 0
                return
            }
            let attribute: AttributeType = task.enemyTypes[offset]
            enemyType.image = attribute.image
            enemyType.alpha = 1
        }
    }
}
