import UIKit

class BorderedButton: UIButton {
    @IBInspectable var strokeSize: CGFloat = 0
    @IBInspectable var strokeColor: UIColor = .clear
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.3
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        let textColor = self.titleLabel!.textColor
        
        context.setLineWidth(self.strokeSize)
        context.setLineJoin(.round)
        context.setTextDrawingMode(.stroke)
        self.titleLabel!.textColor = self.strokeColor
        self.titleLabel!.drawText(in: rect)
        
        context.setTextDrawingMode(.fill)
        self.titleLabel!.textColor = textColor
        self.titleLabel!.drawText(in: rect)

    }
}
