import UIKit
import RxSwift
import RxCocoa

class ParameterBarView: UIView {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var currentValueLabel: BorderedLabel!
    @IBOutlet weak var addValueLabel: CommonFontLabel!
    @IBOutlet weak var synbolImageView: UIImageView!
    
    private let maxProgerss: Float = 999
    private var type: ParameterType! {
        didSet {
            self.progressView.tintColor = type.color
            self.synbolImageView.image = type.image
        }
    }
    private var currentValue: Int64! {
        didSet { self.currentValueLabel.text = String(currentValue) }
    }
    private var addValue: Int64 = 0 {
        didSet {
            self.progressView.progress = Float(self.currentValue + addValue) / self.maxProgerss
            guard addValue > 0 else { self.addValueLabel.text = nil; return }
            self.addValueLabel.text = "+\(addValue)"
        }
    }
    private let typeRelay = PublishRelay<ParameterType>()
    var typeObserver: Observable<ParameterType> {
        return typeRelay.asObservable()
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
        guard let customView = Bundle.main.loadNibNamed("ParameterBarView", owner: self, options: nil)?.first as? UIView else { return }
        customView.frame = self.bounds
        customView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(customView)
        self.backgroundColor = .clear
        self.addValueLabel.text = nil
    }
    
    func configure(type: ParameterType, value: Int64) {
        self.type = type
        self.currentValue = value
        self.progressView.progress = Float(value) / self.maxProgerss
    }
    
    func increment() {
        self.addValue += 1
    }
    
    func decrement() {
        guard self.addValue > 0 else { return }
        self.addValue -= 1
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.typeRelay.accept(self.type)
    }
}

enum ParameterType {
    case hp
    case attribute(type: AttributeType)
    
    var color: UIColor {
        switch self {
        case .hp:
            return UIColor(named: "hpBarColor")!
        case .attribute(let type):
            return type.color
        }
    }
    
    var image: UIImage {
        switch self {
        case .hp:
            return UIImage(named: "heart_with_hp")!
        case .attribute(let type):
            return type.image
        }
    }
}
