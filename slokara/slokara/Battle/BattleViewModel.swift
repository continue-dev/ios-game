import RxSwift
import RxCocoa

final class BattleViewModel {
    private let battleModel: BattleModelProtocol
    private let disposeBag = DisposeBag()
    
    // ここはDBから取得する
    private let reelLine = ReelLine.triple
    private var userParameter: UserParameter!
    
    private var stage: Stage! {
        didSet {
            self.backGround = Observable.just(stage.backGround)
            self.numberOfEnemy = Observable.just(stage.enemies.count)
            self.enemy = stage.enemies.first
        }
    }
    private var currentStep = 0
    private var enemy: Enemy! { didSet { currentEnemy.accept(enemy) } }
    lazy var currentEnemy = BehaviorRelay<Enemy>(value: self.stage.enemies.first!)
    var backGround: Observable<UIImage>!
    var numberOfEnemy: Observable<Int>!
   
    let reelStart: Observable<Void>
    var reelActionResults: Observable<[AttributeType]>!
    
    // プレイヤーの攻撃
    private let playerAttackRelay = PublishRelay<Int64>()
    var playerAttack: Observable<Int64> { return playerAttackRelay.asObservable() }
    
    // 次のステップに進める
    private let toNextEvent = PublishRelay<Void>()
    var toNextStep: Observable<Void> { return self.toNextEvent.asObservable() }
    
    // 敵の攻撃
    private let toEnemyEvent = PublishRelay<Void>()
    var toEnemyTurn: Observable<Void> { return self.toEnemyEvent.asObservable() }
    
    // 敵の攻撃時の数値を流しておくRelay
    private let enemyAttackPowerRelay = BehaviorRelay<Int64>(value: 0)
    var damageFromEnemy: Observable<Int64> { return self.enemyAttackPowerRelay.asObservable() }
    
    // 次の敵を表示させる
    private let startWithNewEnemyRelay = PublishRelay<Enemy>()
    var startWithNewEnemy: Observable<Enemy> { return self.startWithNewEnemyRelay.asObservable() }
    
    // ステージクリア
    private let stageClearRelay = PublishRelay<Void>()
    var stageClear: Observable<Void> { return self.stageClearRelay.asObservable() }
    
    init(screenTaped: Observable<Bool>, reelStoped: Observable<[AttributeType]>, playerAttacked: Observable<Int64>, requestNextEnemy: Observable<Void>, battleModel: BattleModelProtocol) {
        self.battleModel = battleModel

        self.reelStart = screenTaped.filter{ !$0 }.map{_ in }.throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance)
        
        self.reelActionResults = screenTaped.filter{ $0 }.throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance).map{ [unowned self] _ in
            [Probability](repeating: self.enemy.probability, count: self.reelLine.numberOfCharacter).map{prob in prob.randomElement() }
        }
        
        self.battleModel.userParameter.subscribe(onNext: { [weak self] param in
            self?.userParameter = param
            }).disposed(by: disposeBag)
        
        self.battleModel.currentStage.subscribe(onNext: { [weak self] stage in
            self?.stage = stage
        }).disposed(by: disposeBag)
        
        reelStoped.subscribe(onNext: { [weak self] results in
            self?.acceptAttack(results: results)
        }).disposed(by: disposeBag)
        
        playerAttacked.subscribe(onNext: { [weak self] power in
            self?.checkEnemyLife(damage: power)
        }).disposed(by: disposeBag)
        
        requestNextEnemy.subscribe(onNext: { [unowned self] in
            self.enemy = self.stage.enemies[self.currentStep]
            self.startWithNewEnemyRelay.accept(self.enemy)
        }).disposed(by: disposeBag)
    }
    
    private func acceptAttack(results: [AttributeType]) {
        // TODO: ダメージ計算ロジック
        let attackPower = results.map{ [unowned self] result in
            self.userParameter.attackPower(of: result)
        }.reduce(0) { $0 + $1 }
        self.playerAttackRelay.accept(attackPower)
        
        // resultsを引き回さずに済むように、ここで敵の攻撃もacceptしておく。subscribe側でtoEnemyTurnをwithLatestFromする事で任意のタイミングで受け取れる
        let damage = results.filter{ $0 == .enemy}.map{ [unowned self] _ in self.enemy.attack }.reduce(0){ $0 + $1 } - self.userParameter.defense
        self.enemyAttackPowerRelay.accept(damage > 0 ? damage : 0)
    }
    
    private func checkEnemyLife(damage: Int64) {
        self.enemy.hp -= damage
        if self.enemy.hp > 0 {
            self.battleModel.culcUserHp(-self.enemyAttackPowerRelay.value)
            self.toEnemyEvent.accept(())
        } else {
            guard self.currentStep < self.stage.enemies.count - 1 else { self.stageClearRelay.accept(()); return }
            self.currentStep += 1
            self.toNextEvent.accept(())
        }
    }
}
