import UIKit

class TaskCellView: UIView {
    @IBOutlet private weak var taskNameLable: CommonFontLabel!
    @IBOutlet private weak var enemyTypeView: UIStackView!
    @IBOutlet private weak var emblemImageView: UIImageView!
    @IBOutlet private weak var coinLabel: CommonFontLabel!
    @IBOutlet private weak var newLabel: BorderedLabel!
    @IBOutlet private weak var creditLabel: CommonFontLabel!
    @IBOutlet private weak var rankLabel: BorderedLabel!
    @IBOutlet private weak var passedStampImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
    
    private func loadNib() {
        guard let view = Bundle.main.loadNibNamed("TaskCellView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }
    
    func setTask(_ task: Task) {
        taskNameLable.text = task.name
        emblemImageView.image = task.targetGrade.emblemImage
        rankLabel.text = "\(task.targetRank)"
        rankLabel.strokeColor = task.targetGrade.textBorderColor
        creditLabel.text = "\(task.rewardCredits)"
        coinLabel.text = "\(task.rewardCoins)"
        newLabel.isHidden = !task.isNew
        passedStampImageView.isHidden = !task.isPassed
        
        if enemyTypeView.subviews.count > 0 {
            enemyTypeView.subviews.forEach { $0.removeFromSuperview() }
        }
        task.enemyTypes.forEach { type in
            let enemyTypeImageView = UIImageView(image: type.image)
            enemyTypeImageView.contentMode = .scaleAspectFit
            enemyTypeView.addArrangedSubview(enemyTypeImageView)
        }
        // 表示属性が2つの場合はレイアウト調整のため前後に空のImageViewを挿入
        if task.enemyTypes.count == 2 {
            enemyTypeView.addArrangedSubview(UIImageView())
            enemyTypeView.insertArrangedSubview(UIImageView(), at: 0)
        }
    }
}
