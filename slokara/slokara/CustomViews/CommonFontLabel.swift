import UIKit

class CommonFontLabel: UILabel {
    private let fontName = "07LogoTypeGothic7"
    
    // 外部からのフォント変更を防止
    override var font: UIFont!{
        didSet {
            if font.familyName != fontName {
                font = UIFont(name: fontName, size: font.pointSize)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setFont()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setFont()
    }
    
    private func setFont() {
        self.font = UIFont(name: fontName, size: self.font.pointSize)
    }
    
    func setFontSize(size: CGFloat) {
        self.font = UIFont(name: fontName, size: size)
    }
}
