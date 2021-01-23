import UIKit

class ReelStatusView: UIView {
    
    @IBOutlet private weak var topBridgeView: UIView!
    @IBOutlet private weak var bottomBredgeView: UIView!
    @IBOutlet private weak var leftBredgeView: UIView!
    @IBOutlet private weak var rightBredgeView: UIView!
    @IBOutlet private weak var topLeftCornerView: UIView!
    @IBOutlet private weak var topRightCornerView: UIView!
    @IBOutlet private weak var bottomLeftCornerView: UIView!
    @IBOutlet private weak var bottomRightCornerView: UIView!
    @IBOutlet private weak var reelImageView: UIImageView!
    @IBOutlet private weak var titleLabel: BorderedLabel!
    
    private var statusType: ShopReelStatus = .disable {
        didSet {
            applyState(type: statusType)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setState(type: ShopReelStatus) {
        statusType = type
    }
    
    private func applyState(type: ShopReelStatus) {        
        if case .hold(let contacts) = type {
            backgroundColor = .black
            topBridgeView.isHidden = !contacts.contains(.top)
            bottomBredgeView.isHidden = !contacts.contains(.bottom)
            leftBredgeView.isHidden = !contacts.contains(.left)
            rightBredgeView.isHidden = !contacts.contains(.right)
            
            applyCornerView(contacts: contacts)
        } else {
            backgroundColor = .clear
        }
        
        reelImageView.image = type.reelImage
        titleLabel.text = type.title
        titleLabel.textColor = type.titleColor
        titleLabel.strokeSize = type == .selected ? 2 : 0
    }
    
    private func applyCornerView(contacts: [ShopReelStatus.ContactArea]) {
        let currentSet = Set(contacts)
        topLeftCornerView.isHidden = !Set<ShopReelStatus.ContactArea>([.top, .left, .topLeft]).isSubset(of: currentSet)
        topRightCornerView.isHidden = !Set<ShopReelStatus.ContactArea>([.top, .right, .topRight]).isSubset(of: currentSet)
        bottomLeftCornerView.isHidden = !Set<ShopReelStatus.ContactArea>([.bottom, .left, .bottomLeft]).isSubset(of: currentSet)
        bottomRightCornerView.isHidden = !Set<ShopReelStatus.ContactArea>([.right, .bottom, .bottomRight]).isSubset(of: currentSet)
    }
    
    private func setUp() {
        guard let view = Bundle.main.loadNibNamed("ReelStatusView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
        
        titleLabel.setFont(.logoTypeGothic)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        addGestureRecognizer(recognizer)
    }
    
    @objc
    private func didTap(_ sender: UITapGestureRecognizer) {
        switch statusType {
        case .onSale:
            statusType = .selected
        case .selected:
            statusType = .onSale
        default:
            return
        }
    }
    
    enum ShopReelStatus: Equatable {
        case onSale                 // 購入可能
        case selected               // 選択中
        case hold([ContactArea])    // 保有済
        case center                 // 縦横4つのリールも含めて保有済
        case disable                // 非表示
        
        var reelImage: UIImage? {
            switch self {
            case .center, .hold(_):
                return UIImage(named: "shop_reel_acquired")
            case .onSale:
                return UIImage(named: "shop_reel_sale")
            case .selected:
                return UIImage(named: "shop_reel_selected")
            default:
                return nil
            }
        }
        
        var title: String {
            switch self {
            case .center, .hold(_):
                return "取得済み"
            case .onSale:
                return "購入する"
            case .selected:
                return "選択中"
            default:
                return ""
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .center, .hold(_):
                return .black
            case .onSale, .selected:
                return .white
            default:
                return .clear
            }
        }
        
        enum ContactArea {
            case top, bottom, left, right, topLeft, topRight, bottomLeft, bottomRight
        }
    }
}
