import UIKit
import RxSwift
import RxCocoa

class ParameterViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet weak var barStackView: UIStackView!
    @IBOutlet weak var distributeExpLabel: CommonFontLabel!
    @IBOutlet weak var totalExpLabel: CommonFontLabel!
    @IBOutlet weak var operationScrollView: UIScrollView!
    @IBOutlet weak var scrollContentStackView: UIStackView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    
    private let disposeBag = DisposeBag()
    private lazy var viewModel = ParameterViewModel(operationScrolled: self.operationScrollView.rx.didScroll.withLatestFrom(self.operationScrollView.rx.contentOffset).throttle(RxTimeInterval.milliseconds(300), latest: true, scheduler: MainScheduler.instance).map{ Int(round($0.y / self.operationScrollView.bounds.height))})
    
    private var totalExp = 0 {
        didSet { self.totalExpLabel.text = String(totalExp) }
    }
    private var distributeExp = 0 {
        didSet { self.distributeExpLabel.text = String(distributeExp) }
    }
    private var editingType: EditingType! {
        didSet {
            self.minusButton.isHidden = editingType == .enter
            self.plusButton.isHidden = editingType == .enter
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
    
    private func setUp() {
        self.editingType = .enter
    }
    
    private func bind() {
        self.viewModel.parametrts.bind(to: setUpParams).disposed(by: disposeBag)
        self.viewModel.distributeExp.subscribe(onNext: { [weak self] exp in
            self?.distributeExp = exp
        }).disposed(by: disposeBag)
        self.viewModel.editingType.bind(to: editingSelected).disposed(by: disposeBag)
        self.barStackView.arrangedSubviews.forEach { [unowned self] view in
            guard let barView = view as? ParameterBarView else { return }
            barView.typeObserver.map{ EditingType(parameterType: $0) }.bind(to: self.barViewTapped).disposed(by: disposeBag)
        }
    }
    
    private func applyEditingType(type: EditingType) {
        self.barStackView.arrangedSubviews.enumerated().forEach { offset, element in
            guard type.rawValue > 0 else { element.alpha = 1; return }
            element.alpha = offset == type.rawValue - 1 ? 1 : 0.3
        }
    }
}

extension ParameterViewController {
    private var setUpParams: Binder<[(type: ParameterType, value: Int64)]> {
        return Binder(self) { me, params in
            me.totalExp = params.map{Int($0.value)}.reduce(0){ $0 + $1 }
            me.barStackView.arrangedSubviews.enumerated().forEach { offset, element in
                guard offset < params.count else { return }
                guard let barView = element as? ParameterBarView else { return }
                barView.configure(type: params[offset].type, value: params[offset].value)
            }
            me.scrollContentStackView.arrangedSubviews.enumerated().forEach { offset, element in
                guard offset > 0, offset - 1 < params.count else { return }
                guard let imageView = element.subviews.first as? UIImageView else { return }
                imageView.image = params[offset - 1].type.image
            }
        }
    }
    
    private var editingSelected: Binder<EditingType> {
        return Binder(self) { me, type in
            me.editingType = type
            me.applyEditingType(type: type)
        }
    }
    
    private var barViewTapped: Binder<EditingType> {
        return Binder(self) { me, type in
            let currentType = me.editingType == type ? .enter : type
            me.editingType = currentType
            me.applyEditingType(type: currentType)
            me.operationScrollView.contentOffset = CGPoint(x: 0, y: me.operationScrollView.bounds.height * CGFloat(Float(currentType.rawValue)))
        }
    }
}
