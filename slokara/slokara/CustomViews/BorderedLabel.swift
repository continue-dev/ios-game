import UIKit
import RxCocoa

class BorderedLabel: UILabel {
    @IBInspectable var strokeSize: CGFloat = 0
    @IBInspectable var strokeColor: UIColor = .clear {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0
    @IBInspectable var topPadding: CGFloat = 0
    @IBInspectable var bottomPadding: CGFloat = 0

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setUp()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setUp()
//    }
//    
//    private func setUp() {
//        print(self.font.familyName)
//        guard self.font.familyName == UIFont.systemFont(ofSize: 0).familyName else { return }
//        self.setFont(.logoTypeGothic)
//    }
    
    func setFont(_ font: FontType) {
        self.font = UIFont(name: font.rawValue, size: self.font.pointSize)
    }
    
    var borderColor: Binder<UIColor> {
        return Binder(self) { me, color in
            me.strokeColor = color
        }
    }
    
    override func drawText(in rect: CGRect) {
        let newRect = rect.inset(by: UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding))

        let context = UIGraphicsGetCurrentContext()!
        let textColor = self.textColor
        
        context.setLineWidth(self.strokeSize)
        context.setLineJoin(.round)
        context.setTextDrawingMode(.stroke)
        self.textColor = self.strokeColor
        super.drawText(in: newRect)
        
        context.setTextDrawingMode(.fill)
        self.textColor = textColor

        super.drawText(in: newRect)
    }
}

enum FontType: String {
    case logoTypeGothic = "07LogoTypeGothic7"
    case oranienbaum = "Oranienbaum"
}
