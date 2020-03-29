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
    @IBOutlet weak var reelHeader: UIImageView!
    
    private let disposeBag = DisposeBag()
    private let screenTapped = PublishRelay<Bool>()
    private let reelStoped = PublishRelay<[AttributeType]>()
    private let playerAttacked = PublishRelay<Int64>()
    private let requesrNextEnemy = PublishRelay<Void>()
    var stageId: Int!
    
    private lazy var viewModel = BattleViewModel(screenTaped: screenTapped.asObservable(), reelStoped: reelStoped.asObservable(), playerAttacked: playerAttacked.asObservable(), requestNextEnemy: requesrNextEnemy.asObservable(), battleModel: BattleModelImpl(stageId: stageId))

    
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
        viewModel.toNextStep.bind(to: goNextStep).disposed(by: disposeBag)
        viewModel.toEnemyTurn.withLatestFrom(viewModel.damageFromEnemy).bind(to: goEnemyTurn).disposed(by: disposeBag)
        viewModel.startWithNewEnemy.bind(to: startNext).disposed(by: disposeBag)
        viewModel.stageClear.bind(to: stageCleared).disposed(by: disposeBag)
        
        self.reelView.reelStopped.subscribe(onNext: { [weak self] results in
            self?.reelStoped.accept(results)
        }).disposed(by: disposeBag)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.screenTapped.accept(self.reelView.isAnimating)
    }
}

// Private method
extension BattleViewController {
    private func startGame() {
        self.showEnemy { self.view.isUserInteractionEnabled = true }
    }
    
    private func swing(views: [UIView], buffa: CGFloat, _ completion: (() -> ())? = nil) {
        UIView.animateKeyframes(withDuration: 0.1, delay: 0, options: .autoreverse, animations: {
            views.forEach{ $0.transform = CGAffineTransform(translationX: buffa, y: -buffa / 2) }
        }) { _ in
            UIView.animateKeyframes(withDuration: 0.1, delay: 0, options: .autoreverse, animations: {
                views.forEach { $0.transform = CGAffineTransform(translationX: -buffa, y: buffa / 2) }
            }) { [weak self] (_) in
                let buffa = buffa - 4
                guard buffa > 0 else {
                    views.forEach { $0.transform = .identity }
                    completion?()
                    return
                }
                self?.swing(views: views, buffa: buffa, completion)
            }
        }
    }
    
    private func showEnemy(delay: TimeInterval = 0, _ completion: (() -> ())? = nil) {
        UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseIn, animations: { [weak self] in
            self?.enemyImageView.alpha = 1
        }) { (_) in
            completion?()
        }
    }
    
    private func hideEnemy(_ completion: (() -> ())? = nil) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.enemyImageView.alpha = 0
        }) { (_) in
            completion?()
        }
    }
}


// Binder
extension BattleViewController {
    // リール始動
    private var startReelAction: Binder<Void> {
        return Binder(self) { me, _ in
            me.reelView.startAnimation()
        }
    }
    
    // リール停止
    private var stopReelAction: Binder<[AttributeType]> {
        return Binder(self) { me, value in
            me.reelView.stopAnimation(results: value)
        }
    }
    
    // 攻撃
    private var playerAttack: Binder<Int64> {
        return Binder(self) { me, value in
            me.view.isUserInteractionEnabled = false
            me.swing(views: [me.enemyImageView], buffa: 4) { [weak self] in
                self?.playerAttacked.accept(value)
            }
        }
    }
    
    // 次のステップへ
    private var goNextStep: Binder<Void> {
        return Binder(self) { me, _ in
            me.hideEnemy(){ [weak self] in self?.requesrNextEnemy.accept(()) }
        }
    }
    
    // 防御
    private var goEnemyTurn: Binder<Int64> {
        return Binder(self) { me, damage in
            guard damage > 0 else { self.view.isUserInteractionEnabled = true; return }
            if damage > 30 {
                me.swing(views: [me.baseView], buffa: 8) { [weak self] in
                    self?.view.isUserInteractionEnabled = true
                }
            } else {
                me.swing(views: [me.reelView, me.reelHeader, me.autoButton], buffa: 4) { [weak self] in
                    self?.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    // 新しい敵を表示
    private var startNext: Binder<Void> {
        return Binder(self) { me, _ in
            me.progressView.nextStep()
            me.showEnemy(delay: 0.5) { [weak self] in
                self?.view.isUserInteractionEnabled = true
            }
        }
    }
    
    // ステージクリア
    private var stageCleared: Binder<Void> {
        return Binder(self) { me, _ in
            me.hideEnemy() { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
