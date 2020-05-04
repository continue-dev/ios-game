import UIKit
import RxSwift
import RxCocoa

class ParameterBarView: UIView {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var currentValueLabel: BorderedLabel!
    @IBOutlet weak var addValueLabel: CommonFontLabel!
    @IBOutlet weak var synbolImageView: UIImageView!
    
    private let maxProgerss: Float = 999
    private var type: EditParamType! {
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
            self.addValueLabel.text = addValue >= 0 ? "+\(addValue)" : "\(addValue)"
            
            #if !PROD
            if UserDefaults.standard.bool(forKey: "tuningMode") { return }
            #endif
            
            self.addValueLabel.isHidden = addValue <= 0
        }
    }
    private let typeRelay = PublishRelay<EditParamType>()
    var typeObserver: Observable<EditParamType> {
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
    
    func configure(editParmeter: EditParameter) {
        self.type = editParmeter.type
        self.currentValue = editParmeter.baseValue
        self.addValue = editParmeter.addValue
        self.progressView.progress = Float(currentValue + addValue) / self.maxProgerss
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.typeRelay.accept(self.type)
    }
}
