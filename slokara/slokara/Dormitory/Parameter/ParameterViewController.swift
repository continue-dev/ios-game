import UIKit
import RxSwift
import RxCocoa

class ParameterViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet weak var barStackView: UIStackView!
    @IBOutlet weak var distributeExpLabel: CommonFontLabel!
    @IBOutlet weak var totalExpLabel: CommonFontLabel!
    
    private let disposeBag = DisposeBag()
    private lazy var viewModel = ParameterViewModel()
    
    private var totalExp = 0 {
        didSet { self.totalExpLabel.text = String(totalExp) }
    }
    private var distributeExp = 0 {
        didSet { self.distributeExpLabel.text = String(distributeExp) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        self.viewModel.parametrts.bind(to: setUpParams).disposed(by: disposeBag)
        self.viewModel.distributeExp.subscribe(onNext: { [weak self] exp in
            self?.distributeExp = exp
            
            }).disposed(by: disposeBag)
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
        }
    }
}
