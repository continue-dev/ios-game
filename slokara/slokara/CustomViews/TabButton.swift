import UIKit

class TabButton: UIButton {
    
    @IBInspectable var hilightedColor: UIColor = .white
    
    var tabState: TabState = .normal {
        didSet {
            switch tabState {
            case .normal:
                self.alpha = 1
                self.isEnabled = true
                self.backgroundColor = .white
                self.setTitleColor(hilightedColor, for: .normal)
            case .selected:
                self.alpha = 1
                self.isEnabled = true
                self.backgroundColor = .clear
                self.setTitleColor(.white, for: .normal)
            case .disable:
                self.alpha = 0
                self.isEnabled = false
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyDesign()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        applyDesign()
    }
    
    private func applyDesign() {
        self.titleLabel?.font = UIFont(name: "07LogoTypeGothic7", size: self.titleLabel!.font.pointSize)
        self.layer.cornerRadius = 5
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    }
    
    enum TabState {
        case normal
        case selected
        case disable
    }
}

