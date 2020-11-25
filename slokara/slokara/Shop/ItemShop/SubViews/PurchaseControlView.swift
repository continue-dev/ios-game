import UIKit
import RxSwift
import RxCocoa

class PurchaseControlView: UIView {
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemInfoLabel: CommonFontLabel!
    @IBOutlet private weak var purchaseNumberLabel: CommonFontLabel!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
        
    lazy var plusButtonTapped = plusButton.rx.tap.asObservable()
    lazy var minusButtonTapped = minusButton.rx.tap.asObservable()
        
    private let downSwipeRelay = PublishRelay<Void>()
    var hideViewEvent: Observable<Void> {
        return downSwipeRelay.asObservable()
    }
    
    private var currentPurchaseNumber = 0 {
        didSet {
            purchaseNumberLabel.text = "\(currentPurchaseNumber)"
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
    
    func setPurchaseNumber(_ num: Int) {
        currentPurchaseNumber = num
    }
    
    @IBAction private func swipeAction(_ sender: Any) {
        downSwipeRelay.accept(())
    }
}
