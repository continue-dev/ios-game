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
    
    var didSelected = false {
        didSet { applyViewSelection(selected: didSelected) }
    }
    
    func setItem(item: Item) {
        iconImageView.image = item.icon
        itemNameLabel.text = item.name
        priceLabel.text = "\(item.price)"
    }
    
    func setPossession(number: Int) {
        possessionNumberLabel.text = "\(number)"
    }
    
    func setPurchase(number: Int) {
        purchaseNumber = number
    }
    
    private func applyPurchaseBorderColor() {
        if purchaseNumber > 0 {
            purchaseNumberLabel.strokeColor = purchaseBorderColor
        } else {
            purchaseNumberLabel.strokeColor = self.isSelected ? selectedBorderColor : .black
        }
    }
    
    private func applyViewSelection(selected: Bool) {
        choosingLayerImageView.isHidden = !selected
        itemNameLabel.strokeColor = selected ? selectedBorderColor : .black
        priceLabel.strokeColor = selected ? selectedBorderColor : .black
        possessionNumberLabel.strokeColor = selected ? selectedBorderColor : .black
        if purchaseNumber == 0 {
            purchaseNumberLabel.strokeColor = selected ? selectedBorderColor : .black
        }
    }
}
