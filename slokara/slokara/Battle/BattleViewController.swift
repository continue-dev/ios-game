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
    @IBOutlet weak var nextEnemyLabel: BorderedLabel!
    @IBOutlet weak var attackDamageLabel: UILabel!
    @IBOutlet weak var defenseDamageLabel: UILabel!
    @IBOutlet weak var tuningView: UIView!
    
    private let disposeBag = DisposeBag()
    private let screenTapped = PublishRelay<Bool>()
    private let reelStoped = PublishRelay<[AttributeType?]>()
    private let playerAttacked = PublishRelay<Int64>()
    private let requestNextEnemy = PublishRelay<Void>()
    var task: Task!
    
    private lazy var viewModel = BattleViewModel(screenTaped: screenTapped.asObservable(), reelStoped: reelStoped.asObservable(), setAutoPlay: autoButton.rx.tap.map {[unowned self] _ in self.autoButton.isOn }, playerAttacked: playerAttacked.asObservable(), requestNextEnemy: requestNextEnemy.asObservable(), battleModel: BattleModelImpl(stageId: task.stageId))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.parent as? NavigationViewController)?.backButtonIsHidden(true)
        self.view.isUserInteractionEnabled = false
        bind()
        
        #if !PROD
        self.tuningView.isHidden = !UserDefaults.standard.bool(forKey: "tuningMode")
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reelView.reel = viewModel.reel
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startGame()
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
        viewModel.isAutoPlay.bind(to: setAutoPlay).disposed(by: disposeBag)
        
        self.reelView.reelStopped.subscribe(onNext: { [weak self] results in
            self?.reelStoped.accept(results)
        }).disposed(by: disposeBag)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !self.autoButton.isOn else { return }
        self.screenTapped.accept(self.reelView.isAnimating)
    }
}

// Private method
extension BattleViewController {
    private func startGame() {
        self.showEnemy { self.waitingForInputIfNeeded() }
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
    
    private func setUpNextEnemyLabel() {
        let attributedString = NSMutableAttributedString(string: "NEXT\nENEMY")
        
        attributedString.addAttribute(.kern, value: -2, range: NSRange(location: 0, length: attributedString.length))
        self.nextEnemyLabel.attributedText = attributedString
        self.nextEnemyLabel.textColor = .white
        self.nextEnemyLabel.strokeColor = UIColor(red: 83 / 255, green: 65 / 255, blue: 35 / 255, alpha: 1)
        self.nextEnemyLabel.numberOfLines = 0
        
        self.nextEnemyLabel.translatesAutoresizingMaskIntoConstraints = true
        self.nextEnemyLabel.center = CGPoint(x: self.view.center.x, y: (self.view.bounds.height - self.reelHeader.bounds.height - self.reelView.bounds.height + 18) / 2 )
    }
    
    private func setUpDangerLabel() {
        let attributedString = NSMutableAttributedString(string: "DANGER")
        
        attributedString.addAttribute(.kern, value: -2, range: NSRange(location: 0, length: attributedString.length))
        self.nextEnemyLabel.attributedText = attributedString
        self.nextEnemyLabel.textColor = UIColor(red: 195 / 255, green: 34 / 255, blue: 10 / 255, alpha: 1)
        self.nextEnemyLabel.strokeColor = .white
        self.nextEnemyLabel.numberOfLines = 1
        
        self.nextEnemyLabel.translatesAutoresizingMaskIntoConstraints = true
        self.nextEnemyLabel.center = CGPoint(x: self.view.center.x, y: (self.view.bounds.height - self.reelHeader.bounds.height - self.reelView.bounds.height + 18) / 2 )
    }
    
    private func showDangerLabel(_ completion: (() -> ())? = nil) {
        setUpDangerLabel()
        self.nextEnemyLabel.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.nextEnemyLabel.alpha = 1
            self?.nextEnemyLabel.transform = .identity
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 0.7, options: .curveEaseIn, animations: { [weak self] in
                self?.nextEnemyLabel.alpha = 0
                self?.nextEnemyLabel.transform = CGAffineTransform(scaleX: 3, y: 3)
            }) { [weak self] (_) in
                self?.nextEnemyLabel.transform = .identity
                completion?()
            }
        }
    }
    
    private func showNextEnemyLabel(_ completion: (() -> ())? = nil) {
        setUpNextEnemyLabel()
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            self?.nextEnemyLabel.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 0.5, options: .curveEaseIn, animations: {[weak self] in
                self?.nextEnemyLabel.alpha = 0
            }) { (_) in
                completion?()
            }
        }
    }
    
    private func setItemButtonsInteraction(isEnable: Bool) {
        self.firstItemButton.isUserInteractionEnabled = isEnable
        self.secondItemButton.isUserInteractionEnabled = isEnable
        self.thirdItemButton.isUserInteractionEnabled = isEnable
    }
    
    private func waitingForInputIfNeeded() {
        if self.autoButton.isOn {
            self.screenTapped.accept(self.reelView.isAnimating)
        } else {
            self.view.isUserInteractionEnabled = true
        }
    }
}


// Binder
extension BattleViewController {
    // リール始動
    private var startReelAction: Binder<Void> {
        return Binder(self) { me, _ in
            me.reelView.startAnimation()
            // For tuning mode.
            me.attackDamageLabel.isHidden = true
            me.defenseDamageLabel.isHidden = true
        }
    }
    
    // リール停止
    private var stopReelAction: Binder<[AttributeType?]> {
        return Binder(self) { me, value in
            me.view.isUserInteractionEnabled = false
            me.reelView.stopAnimation(results: value)
        }
    }
    
    private var setAutoPlay: Binder<Bool> {
        return Binder(self) { me, isOn in
            me.setItemButtonsInteraction(isEnable: !isOn)
            
            guard isOn else { return }
            me.screenTapped.accept(me.reelView.isAnimating)
        }
    }
    
    // 攻撃
    private var playerAttack: Binder<Int64> {
        return Binder(self) { me, value in
            // For tuning mode.
            me.attackDamageLabel.text = "\(value)"
            me.attackDamageLabel.isHidden = false
            
            if value > 0 {
                me.swing(views: [me.enemyImageView], buffa: 4) { [weak self] in
                    self?.playerAttacked.accept(value)
                }
            } else {
                self.playerAttacked.accept(value)
            }
        }
    }
    
    // 次のステップへ
    private var goNextStep: Binder<Void> {
        return Binder(self) { me, _ in
            me.hideEnemy(){ [weak self] in
                self?.requestNextEnemy.accept(())
            }
        }
    }
    
    // 防御
    private var goEnemyTurn: Binder<Int64> {
        return Binder(self) { me, damage in
            // For tuning mode.
            me.defenseDamageLabel.text = "\(damage)"
            me.defenseDamageLabel.isHidden = false
            
            guard damage > 0 else { self.waitingForInputIfNeeded(); return }
            if damage > 30 {
                me.swing(views: [me.baseView], buffa: 8) { [weak self] in
                    self?.waitingForInputIfNeeded()
                }
            } else {
                me.swing(views: [me.reelView, me.reelHeader, me.autoButton], buffa: 4) { [weak self] in
                    self?.waitingForInputIfNeeded()
                }
            }
        }
    }
    
    // 新しい敵を表示
    private var startNext: Binder<Enemy> {
        return Binder(self) { me, enemy in
            switch enemy.type {
            case .small:
                me.showNextEnemyLabel() { [weak self] in
                    self?.progressView.nextStep()
                    self?.showEnemy(delay: 0.5) { [weak self] in
                        self?.waitingForInputIfNeeded()
                    }
                }
            case .big:
                me.showDangerLabel() { [weak self] in
                    self?.progressView.nextStep()
                    self?.showEnemy(delay: 0.5) { [weak self] in
                        self?.waitingForInputIfNeeded()
                    }
                }
            }
        }
    }
    
    // ステージクリア
    private var stageCleared: Binder<Void> {
        return Binder(self) { me, _ in
            me.hideEnemy() { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let navigation = me.parent as! NavigationViewController
                    let clearedVC = UIStoryboard(name: "Cleared", bundle: nil).instantiateInitialViewController() as! ClearedViewController
                    clearedVC.task = self?.task
                    navigation.push(clearedVC, animate: true)
                }
            }
        }
    }
}
