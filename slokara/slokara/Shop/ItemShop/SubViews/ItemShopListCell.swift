import UIKit

class ItemShopListCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var itemNameLabel: BorderedLabel!
    @IBOutlet private weak var priceLabel: BorderedLabel!
    @IBOutlet private weak var possessionNumberLabel: BorderedLabel!
    @IBOutlet private weak var purchaseNumberLabel: BorderedLabel!
    @IBOutlet private weak var choosingLayerImageView: UIImageView!
    
    private let selectedBorderColor = UIColor(red: 36.0/255, green: 109.0/255, blue: 81.0/255, alpha: 1)
    private let purchaseBorderColor = UIColor(red: 238.0/255, green: 17.0/255, blue: 25.0/255, alpha: 1)
    
    var purchaseNumber = 0 {
        didSet {
            purchaseNumberLabel.text = "+\(purchaseNumber)"
            applyPurchaseLabelDesign()
        }
    }
    
    var didSelected = false {
        didSet { applyViewSelection(selected: didSelected) }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemNameLabel.setFont(.logoTypeGothic)
        priceLabel.setFont(.logoTypeGothic)
        possessionNumberLabel.setFont(.logoTypeGothic)
        purchaseNumberLabel.setFont(.logoTypeGothic)
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
    
    private func applyPurchaseLabelDesign() {
        if purchaseNumber > 0 {
            purchaseNumberLabel.layer.shadowColor = UIColor.black.cgColor
            purchaseNumberLabel.layer.shadowOffset = CGSize(width: -1, height: 1)
            purchaseNumberLabel.layer.shadowOpacity = 1
            purchaseNumberLabel.layer.shadowRadius = 0
            purchaseNumberLabel.strokeColor = purchaseBorderColor
            
        } else {
            purchaseNumberLabel.layer.shadowOffset = .zero
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
