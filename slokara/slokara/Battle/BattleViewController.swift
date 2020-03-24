import UIKit
import RxSwift
import RxCocoa

class BattleViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var reelView: ReelView!
    @IBOutlet private weak var progressView: BattleProgressView!
    @IBOutlet private weak var firstItemButton: UIButton!
    @IBOutlet private weak var secondItemButton: UIButton!
    @IBOutlet private weak var thirdItemButton: UIButton!
    @IBOutlet private weak var backGroundImageView: UIImageView!
    @IBOutlet private weak var enemyImageView: UIImageView!
    @IBOutlet private weak var autoButton: ToggleButton!
    
    private let disposeBag = DisposeBag()
    private let screenTapped = PublishRelay<Bool>()
    var stageId: Int!
    
    private lazy var viewModel = BattleViewModel(screenTaped: screenTapped.asObservable(), battleModel: BattleModelImpl(stageId: stageId))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = false
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reelView.line = .triple
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startGame()
    }
    
    func inject(viewModel: BattleViewModel) {
        self.viewModel = viewModel
    }
    
    private func bind() {
        viewModel.backGround.bind(to: backGroundImageView.rx.image).disposed(by: disposeBag)
        viewModel.currentEnemy.map{ $0.image }.bind(to: enemyImageView.rx.image).disposed(by: disposeBag)
        viewModel.numberOfEnemy.subscribe(onNext: { [weak self] number in
            self?.progressView.progressMax = number
            }).disposed(by: disposeBag)
        viewModel.reelStart.bind(to: startReelAction).disposed(by: disposeBag)
        viewModel.reelStop.bind(to: stopReelAction).disposed(by: disposeBag)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.screenTapped.accept(self.reelView.isAnimating)
    }
}

extension BattleViewController {
    private func startGame() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.enemyImageView.alpha = 1
        }) { (_) in
            self.view.isUserInteractionEnabled = true
        }
    }
}

extension BattleViewController {
    private var startReelAction: Binder<Void> {
        return Binder(self) { me, _ in
            me.reelView.startAnimation()
        }
    }
    
    private var stopReelAction: Binder<[AttributeType]> {
        return Binder(self) { me, value in
            me.reelView.stopAnimation(results: value)
        }
    }
}
