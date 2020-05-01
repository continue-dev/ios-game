import UIKit

class ToggleButton: UIButton {
    
    @IBInspectable var normalImage: UIImage? {
        didSet { self.setBackgroundImage(normalImage, for: .normal) }
    }
    @IBInspectable var selectedImage: UIImage?
    @IBInspectable var normalTitle: String = "" {
        didSet { self.setTitle(normalTitle, for: .normal) }
    }
    @IBInspectable var selectedTitle: String?
    
    private let fontName = "07LogoTypeGothic7"

    var isOn: Bool = false {
        didSet {
            let image = isOn ? self.selectedImage : self.normalImage
            self.setBackgroundImage(image, for: .normal)
            let title = isOn ? self.selectedTitle : self.normalTitle
            self.setTitle(title, for: .normal)
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
    
    private func setUp() {
        self.titleLabel?.font = UIFont(name: self.fontName, size: self.titleLabel!.font.pointSize)
        self.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
    }
    
    @objc private func tapped(sender: ToggleButton) {
        self.isOn.toggle()
    }
}
