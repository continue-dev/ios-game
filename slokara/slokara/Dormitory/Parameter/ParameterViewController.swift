import UIKit
import RxSwift
import RxCocoa

class ParameterViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet weak var barStackView: UIStackView!
    
    private let disposeBag = DisposeBag()
    private lazy var viewModel = ParameterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        self.viewModel.parametrts.bind(to: setUpParams).disposed(by: disposeBag)
    }
}

extension ParameterViewController {
    private var setUpParams: Binder<[(type: ParameterType, value: Int64)]> {
        return Binder(self) { me, params in
            me.barStackView.arrangedSubviews.enumerated().forEach { offset, element in
                guard offset < params.count else { return }
                guard let barView = element as? ParameterBarView else { return }
                barView.configure(type: params[offset].type, value: params[offset].value)
            }
        }
    }
}
