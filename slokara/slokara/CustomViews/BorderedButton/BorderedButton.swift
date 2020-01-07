import UIKit
import RxSwift

class BorderedButton: UIView {
    
    @IBOutlet private weak var backImageView: UIImageView!
    @IBOutlet weak var titleLabel: BorderedLabel!
    
    @IBInspectable var strokeSize: CGFloat {
        get { return titleLabel.strokeSize }
        set { titleLabel.strokeSize = newValue }
    }
    @IBInspectable var strokeColor: UIColor {
        get { return titleLabel.strokeColor }
        set { titleLabel.strokeColor = newValue }
    }
    @IBInspectable var backGroundImageForNormal: UIImage? {
        didSet { backImageView.image = backGroundImageForNormal }
    }
    @IBInspectable var backGroundImageForHighlighted: UIImage = UIImage()
    @IBInspectable var title: String? {
        get { return titleLabel.text}
        set { titleLabel.text = newValue}
    }
    @IBInspectable var titleColor: UIColor {
        get { return titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }
    @IBInspectable var fontSize: CGFloat {
        get { return titleLabel.font.pointSize }
        set { titleLabel.font = UIFont(name: fontName, size: newValue) }
    }
    
    private let fontName = "07LogoTypeGothic7"
    private let buttonTappedSubject = PublishSubject<Void>()
    var buttonTapped: Observable<Void> { return buttonTappedSubject }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        guard let view = Bundle.main.loadNibNamed("BorderedButton", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.backgroundColor = .clear
        addSubview(view)
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.minimumScaleFactor = 0.3
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backImageView.image = self.backGroundImageForHighlighted
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backImageView.image = self.backGroundImageForNormal
        self.buttonTappedSubject.onNext(())
    }
}
