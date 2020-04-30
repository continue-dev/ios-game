import UIKit
import RxSwift
import RxCocoa

class AttributeSelectView: UIView {
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var fireImage: ToggleAttributeImageView!
    @IBOutlet private weak var waterImage: ToggleAttributeImageView!
    @IBOutlet private weak var windImage: ToggleAttributeImageView!
    @IBOutlet private weak var soilImage: ToggleAttributeImageView!
    @IBOutlet private weak var lightImage: ToggleAttributeImageView!
    @IBOutlet private weak var darknessImage: ToggleAttributeImageView!
    
    private let disposeBag = DisposeBag()
    private var selectAttributes = [AttributeType]() {
        didSet{ self.selectEvent.accept(selectAttributes) }
    }
    private let selectEvent = PublishRelay<[AttributeType]>()
    var selectAttributesObserver: Observable<[AttributeType]> { return selectEvent.asObservable() }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        applyAttribute()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
        applyAttribute()
        bind()
    }
    
    private func setUp() {
        guard let view = Bundle.main.loadNibNamed("AttributeSelectView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.backgroundColor = .clear
        addSubview(view)
    }
    
    private func applyAttribute() {
        fireImage.setAttribute(attribute: .fire)
        waterImage.setAttribute(attribute: .water)
        windImage.setAttribute(attribute: .wind)
        soilImage.setAttribute(attribute: .soil)
        lightImage.setAttribute(attribute: .light)
        darknessImage.setAttribute(attribute: .darkness)
    }
    
    func setSelected(attributes: [AttributeType]) {
        selectAttributes = attributes
        attributes.forEach{ [weak self] attr in self?.applySelectDisplay(attribute: attr) }
    }
    
    private func applySelectDisplay(attribute: AttributeType) {
        switch attribute {
        case .fire:
            fireImage.isSelected = true
        case .water:
            waterImage.isSelected = true
        case .wind:
            windImage.isSelected = true
        case .soil:
            soilImage.isSelected = true
        case .light:
            lightImage.isSelected = true
        case .darkness:
            darknessImage.isSelected = true
        default:
            break
        }
    }
    
    private func bind() {
        fireImage.didTap.subscribe(onNext: { [weak self] isSelect in
            if let index = self?.selectAttributes.firstIndex(of: .fire) {
                self?.selectAttributes.remove(at: index)
            } else {
                self?.selectAttributes.append(.fire)
            }
        }).disposed(by: disposeBag)
        waterImage.didTap.subscribe(onNext: { [weak self] isSelect in
            if let index = self?.selectAttributes.firstIndex(of: .water) {
                self?.selectAttributes.remove(at: index)
            } else {
                self?.selectAttributes.append(.water)
            }
        }).disposed(by: disposeBag)
        windImage.didTap.subscribe(onNext: { [weak self] isSelect in
            if let index = self?.selectAttributes.firstIndex(of: .wind) {
                self?.selectAttributes.remove(at: index)
            } else {
                self?.selectAttributes.append(.wind)
            }
        }).disposed(by: disposeBag)
        soilImage.didTap.subscribe(onNext: { [weak self] isSelect in
            if let index = self?.selectAttributes.firstIndex(of: .soil) {
                self?.selectAttributes.remove(at: index)
            } else {
                self?.selectAttributes.append(.soil)
            }
        }).disposed(by: disposeBag)
        lightImage.didTap.subscribe(onNext: { [weak self] isSelect in
            if let index = self?.selectAttributes.firstIndex(of: .light) {
                self?.selectAttributes.remove(at: index)
            } else {
                self?.selectAttributes.append(.light)
            }
        }).disposed(by: disposeBag)
        darknessImage.didTap.subscribe(onNext: { [weak self] isSelect in
            if let index = self?.selectAttributes.firstIndex(of: .darkness) {
                self?.selectAttributes.remove(at: index)
            } else {
                self?.selectAttributes.append(.darkness)
            }
        }).disposed(by: disposeBag)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        guard let togglrAttribute = self.stackView.arrangedSubviews.filter({ $0.frame.contains(location) }).first as? ToggleAttributeImageView else { return }
        togglrAttribute.touchesEnded(touches, with: event)
    }
}
