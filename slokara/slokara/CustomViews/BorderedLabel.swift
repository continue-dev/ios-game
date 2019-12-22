import UIKit
import RxCocoa

class BorderedLabel: UILabel {
    @IBInspectable var strokeSize: CGFloat = 0
    @IBInspectable var strokeColor: UIColor = .clear
    
    func setFont(_ font: FontType) {
        self.font = UIFont(name: font.rawValue, size: self.font.pointSize)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        let textColor = self.textColor
        
        context.setLineWidth(self.strokeSize)
        context.setLineJoin(.round)
        context.setTextDrawingMode(.stroke)
        self.textColor = self.strokeColor
        super.drawText(in: rect)
        
        context.setTextDrawingMode(.fill)
        self.textColor = textColor
        super.drawText(in: rect)
    }
    
    var borderColor: Binder<UIColor> {
        return Binder(self) { me, color in
            me.strokeColor = color
        }
    }
}

enum FontType: String {
    case logoTypeGothic = "07LogoTypeGothic7"
    case oranienbaum = "Oranienbaum"
}
