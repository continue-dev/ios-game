import UIKit
import RxSwift
import RxCocoa

class PurchaseControlView: UIView {
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemInfoLabel: CommonFontLabel!
    @IBOutlet private weak var purchaseNumberLabel: CommonFontLabel!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
    
    private let purchaseNumberRelay = BehaviorRelay<Int>(value: 0)
    var purchaseNumber: Observable<Int> {
        return purchaseNumberRelay.asObservable()
    }
    
    private let downSwipeRelay = PublishRelay<Void>()
    var hideViewEvent: Observable<Void> {
        return downSwipeRelay.asObservable()
    }
    
    private var currentPurchaseNumber = 0 {
        didSet {
            purchaseNumberLabel.text = "\(currentPurchaseNumber)"
            purchaseNumberRelay.accept(currentPurchaseNumber)
        }
    }
    private var currentPossessionNum = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
    
    private func loadNib() {
        guard let customView = Bundle.main.loadNibNamed("PurchaseControlView", owner: self, options: nil)?.first as? UIView else { return }
        customView.frame = self.bounds
        customView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(customView)
    }
    
    func setItemListModel(model: ItemListModel) {
        itemImageView.image = model.item.image
        itemInfoLabel.text = model.item.info
        currentPurchaseNumber = model.purchaseNumber
        currentPossessionNum = model.possessionNumber
    }
    
    @IBAction private func plusButtonTapped(_ sender: Any) {
        guard currentPurchaseNumber + currentPossessionNum < 99 else { return }
        currentPurchaseNumber += 1
    }
    
    @IBAction private func minusButtonTapped(_ sender: Any) {
        guard currentPurchaseNumber > 0 else { return }
        currentPurchaseNumber -= 1
    }
    
    @IBAction private func swipeAction(_ sender: Any) {
        downSwipeRelay.accept(())
    }
}
