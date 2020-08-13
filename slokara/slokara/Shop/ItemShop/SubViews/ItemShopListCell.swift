import UIKit

class ItemShopListCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var itemNameLabel: BorderedLabel!
    @IBOutlet private weak var priceLabel: BorderedLabel!
    @IBOutlet private weak var possessionNumberLabel: BorderedLabel!
    @IBOutlet private weak var purchaseNumberLabel: BorderedLabel!
    @IBOutlet private weak var choosingLayerImageView: UIImageView!
    
    private let selectedBorderColor = UIColor(red: 36/255, green: 109/255, blue: 81/255, alpha: 1)
    
    var purchaseNumber = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
}
