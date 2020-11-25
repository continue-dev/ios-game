import UIKit
import RxSwift
import RxCocoa

class CartButton: UIView {
    @IBOutlet private weak var purchaseLabel: CommonFontLabel!
    private var state = ButtonState.normal {
        didSet {
            switch state {
            case .animatingToNormal:
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.frame = CGRect(x: self.frame.minX + self.bounds.height * 2, y: self.frame.minY, width: self.bounds.height, height: self.bounds.height)
                    self.purchaseLabel.alpha = 0
                }) { [unowned self] (_) in
                    self.state = .normal
                    self.purchaseLabel.isHidden = true
                    self.layoutIfNeeded()
                }
            case .animatingToHighlighted:
                self.purchaseLabel.isHidden = false
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.frame = CGRect(x: self.frame.minX - self.bounds.height * 2, y: self.frame.minY, width: self.bounds.height * 3, height: self.bounds.height)
                    self.purchaseLabel.alpha = 1
                }) { [unowned self] (_) in
                    self.state = .highlighted
                    self.layoutIfNeeded()
                }
            default:
                return
            }
        }
    }
    
    private let purchaseRelay = PublishRelay<Void>()
    var purchaseEvent: Observable<Void> {
        return purchaseRelay.asObservable()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyDesign()
    }
    
    private func setUp() {
        guard let view = Bundle.main.loadNibNamed("CartButton", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }

    private func applyDesign() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor(red: 116/255, green: 95/255, blue: 62/255, alpha: 1).cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        self.layer.borderWidth = 6
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = .identity
        self.layer.borderWidth = 4
        switch state {
        case .normal:
            state = .animatingToHighlighted
        case .animatingToHighlighted, .animatingToNormal:
            return
        case .highlighted:
            purchaseRelay.accept(())
        }
    }
    
    private enum ButtonState {
        case normal
        case animatingToHighlighted
        case animatingToNormal
        case highlighted
    }
}

// Internal method
extension CartButton {
    func deSelect() {
        guard state == .highlighted else { return }
        state = .animatingToNormal
    }
}
