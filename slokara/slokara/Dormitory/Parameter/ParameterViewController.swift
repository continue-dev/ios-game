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
    @IBOutlet weak var enterButton: BorderedButton!
    
    
    private let disposeBag = DisposeBag()
    private lazy var didScroll = self.operationScrollView.rx.didScroll
        .withLatestFrom(self.operationScrollView.rx.contentOffset)
        .throttle(RxTimeInterval.milliseconds(300), latest: true, scheduler: MainScheduler.instance)
        .map{ Int(round($0.y / self.operationScrollView.bounds.height))}
    private lazy var viewModel = ParameterViewModel(operationScrolled: self.didScroll, operationTapped: self.operationTappedRelay.asObservable(), plusButtonTapped: self.plusButton.rx.tap.asObservable(), minusButtonTapped: self.minusButton.rx.tap.asObservable(), enterButtonTapped: self.enterButton.buttonTapped)
    
    private let operationTappedRelay = PublishRelay<EditingType>()
    
    private var editingType: EditingType! {
        didSet {
            self.minusButton.isHidden = editingType == .enter
            self.plusButton.isHidden = editingType == .enter
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        self.viewModel.parameterObserver.bind(to: setUpParams).disposed(by: disposeBag)
        self.viewModel.distributeExpObserver.map{ String($0) }.bind(to: self.distributeExpLabel.rx.text).disposed(by: disposeBag)
        self.viewModel.editingTypeObserver.bind(to: editingSelected).disposed(by: disposeBag)
        self.viewModel.editingTypeObserver.map{ $0 == .enter }.bind(to: self.plusButton.rx.isHidden).disposed(by: disposeBag)
        self.viewModel.editingTypeObserver.map{ $0 == .enter }.bind(to: self.minusButton.rx.isHidden).disposed(by: disposeBag)
        self.viewModel.scrollOffset.bind(to: operationScroll).disposed(by: disposeBag)
        self.viewModel.totalExpObserver.map{ String($0) }.bind(to: self.totalExpLabel.rx.text).disposed(by: disposeBag)
        self.viewModel.popScreen.bind(to: transitionBack).disposed(by: disposeBag)
        
        self.barStackView.arrangedSubviews.forEach { [unowned self] view in
            guard let barView = view as? ParameterBarView else { return }
            barView.typeObserver.map{ EditingType(editParamType: $0) }.subscribe(onNext: { [weak self] type in
                self?.operationTappedRelay.accept(type)
            }).disposed(by: disposeBag)
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
    private var setUpParams: Binder<[EditParameter]> {
        return Binder(self) { me, params in
            me.barStackView.arrangedSubviews.enumerated().forEach { offset, element in
                guard offset < params.count else { return }
                guard let barView = element as? ParameterBarView else { return }
                barView.configure(editParmeter: params[offset])
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
            me.applyEditingType(type: type)
        }
    }
    
    private var operationScroll: Binder<Int> {
        return Binder(self) { me, offset in
            me.operationScrollView.contentOffset = CGPoint(x: 0, y: me.operationScrollView.bounds.height * CGFloat(offset))
        }
    }
    
    private var transitionBack: Binder<Void> {
        return Binder(self) { me, _ in
            guard let navigation = me.parent as? NavigationViewController else { return }
            navigation.popViewController(animate: true)
        }
    }
}
