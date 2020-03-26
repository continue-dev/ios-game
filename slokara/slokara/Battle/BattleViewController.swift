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
    private let reelStoped = PublishRelay<[AttributeType]>()
    var stageId: Int!
    
    private lazy var viewModel = BattleViewModel(screenTaped: screenTapped.asObservable(), reelStoped: reelStoped.asObservable(), battleModel: BattleModelImpl(stageId: stageId))

    
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
        viewModel.reelActionResults.bind(to: stopReelAction).disposed(by: disposeBag)
        viewModel.playerAttack.bind(to: playerAttack).disposed(by: disposeBag)
        
        self.reelView.reelStopped.subscribe(onNext: { [weak self] results in
            self?.reelStoped.accept(results)
        }).disposed(by: disposeBag)
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
    
    private func swing(view: UIView, buffa: CGFloat) {
        UIView.animateKeyframes(withDuration: 0.1, delay: 0, options: .autoreverse, animations: {
            view.transform = CGAffineTransform(translationX: buffa, y: -buffa / 2)
        }) { _ in
            UIView.animateKeyframes(withDuration: 0.1, delay: 0, options: .autoreverse, animations: {
                view.transform = CGAffineTransform(translationX: -buffa, y: buffa / 2)
            }) { [weak self] (_) in
                let buffa = buffa - 4
                guard buffa > 0 else {
                    view.transform = .identity
                    return
                }
                self?.swing(view: view, buffa: buffa)
            }
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
    
    private var playerAttack: Binder<Int64> {
        return Binder(self) { me, value in
            me.swing(view: me.enemyImageView, buffa: 4)
        }
    }
}
