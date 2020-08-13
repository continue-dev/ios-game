import UIKit

class ItemShopListCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var itemNameLabel: BorderedLabel!
    @IBOutlet private weak var priceLabel: BorderedLabel!
    @IBOutlet private weak var possessionNumberLabel: BorderedLabel!
    @IBOutlet private weak var purchaseNumberLabel: BorderedLabel!
    @IBOutlet private weak var choosingLayerImageView: UIImageView!
    
    private let selectedBorderColor = UIColor(red: 36/255, green: 109/255, blue: 81/255, alpha: 1)
    private let purchaseBorderColor = UIColor(red: 238/255, green: 17/255, blue: 25/255, alpha: 1)
    
    var purchaseNumber = 0 {
        didSet {
            purchaseNumberLabel.text = "+\(purchaseNumber)"
            applyPurchaseBorderColor()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        choosingLayerImageView.isHidden = !selected
        itemNameLabel.strokeColor = selected ? selectedBorderColor : .black
        priceLabel.strokeColor = selected ? selectedBorderColor : .black
        possessionNumberLabel.strokeColor = selected ? selectedBorderColor : .black
        if purchaseNumber == 0 {
            purchaseNumberLabel.strokeColor = selected ? selectedBorderColor : .black
        }
    }
    
    func setItem(item: Item) {
        iconImageView.image = item.icon
        itemNameLabel.text = item.name
        priceLabel.text = "\(item.price)"
    }
    
    func setPossession(number: Int) {
        possessionNumberLabel.text = "\(number)"
    }
    
    func incrementPurchaseNumber() {
        purchaseNumber += 1
    }
    
    func decrementPurchaseNumber() {
        guard purchaseNumber > 0 else { return }
        purchaseNumber -= 1
    }
    
    private func applyPurchaseBorderColor() {
        if purchaseNumber > 0 {
            purchaseNumberLabel.strokeColor = purchaseBorderColor
        } else {
            purchaseNumberLabel.strokeColor = self.isSelected ? selectedBorderColor : .black
        }
    }
}
