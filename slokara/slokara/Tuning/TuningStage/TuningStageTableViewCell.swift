import UIKit

class TuningStageTableViewCell: UITableViewCell {
    @IBOutlet private weak var enemyImage: UIImageView!
    @IBOutlet private weak var attackTypeStack: UIStackView!
    @IBOutlet private weak var defenceTypeStack: UIStackView!
    @IBOutlet private weak var attackPowerLabel: UILabel!
    @IBOutlet private weak var defencePowerLabel: UILabel!
    @IBOutlet private weak var enemyCharProportionLabel: UILabel!
    @IBOutlet private weak var fireCharProportionLabel: UILabel!
    @IBOutlet private weak var waterCharProportionLabel: UILabel!
    @IBOutlet private weak var windCharProportionLabel: UILabel!
    @IBOutlet private weak var soilCharProportionLabel: UILabel!
    @IBOutlet private weak var lightCharProportionLabel: UILabel!
    @IBOutlet private weak var darknessCharProportionLabel: UILabel!
    
    func setEnemy(enemy: Enemy) {
        self.enemyImage.image = enemy.image
        self.attackTypeStack.subviews.filter{ $0 is UIImageView }.enumerated().forEach { offset, element in
            guard offset < enemy.attackType.count, let imageView = element as? UIImageView else { return }
            imageView.image = enemy.attackType[offset].image
        }
        self.defenceTypeStack.subviews.filter{ $0 is UIImageView }.enumerated().forEach { offset, element in
            guard offset < enemy.defenseType.count, let imageView = element as? UIImageView else { return }
            imageView.image = enemy.defenseType[offset].image
        }
        self.attackPowerLabel.text = "\(enemy.attack)"
        self.defencePowerLabel.text = "\(enemy.defense)"
        self.enemyCharProportionLabel.text = "\(enemy.probability.enemy)"
        self.fireCharProportionLabel.text = "\(enemy.probability.fire)"
        self.waterCharProportionLabel.text = "\(enemy.probability.water)"
        self.windCharProportionLabel.text = "\(enemy.probability.wind)"
        self.soilCharProportionLabel.text = "\(enemy.probability.soil)"
        self.lightCharProportionLabel.text = "\(enemy.probability.light)"
        self.darknessCharProportionLabel.text = "\(enemy.probability.darkness)"
    }
}
