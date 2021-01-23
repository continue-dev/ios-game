import UIKit
import RxSwift
import RxCocoa

class ReelShopViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet private weak var enterButton: BorderedButton!
    @IBOutlet private weak var currentCoinsLabel: BorderedLabel!
    @IBOutlet private weak var paymentCoinsLabel: BorderedLabel!
    @IBOutlet private weak var shoppingView: ReelShoppingView!
    
    private let disposeBag = DisposeBag()
    private lazy var viewModel = ReelShopViewModel(reelStatus: shoppingView.reelStateObservable)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        viewModel.currentCoins.map { "\($0)" }.bind(to: currentCoinsLabel.rx.text).disposed(by: disposeBag)
        viewModel.paymentCoins.map { "\($0)" }.bind(to: paymentCoinsLabel.rx.text).disposed(by: disposeBag)
        viewModel.currentReel.subscribe(onNext: { [weak self] reel in
            self?.shoppingView.setReelStatus(reel: reel)
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.currentCoins, viewModel.paymentCoins)
            .map { current, payment in
                payment <= current
            }
            .bind(to: canSopping)
            .disposed(by: disposeBag)
    }
}

extension ReelShopViewController {
    private var canSopping: Binder<Bool> {
        return Binder(self) { me, can in
            me.paymentCoinsLabel.textColor = can ? .white : .red
            me.enterButton.isHidden = !can
        }
    }
}
