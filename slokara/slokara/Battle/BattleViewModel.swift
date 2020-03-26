import RxSwift
import RxCocoa

final class BattleViewModel {
    private let battleModel: BattleModelProtocol
    private let disposeBag = DisposeBag()
    
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
    private var enemy: Enemy! {
        didSet { currentEnemy.accept(enemy) }
    }
    
    lazy var currentEnemy = BehaviorRelay<Enemy>(value: self.stage.enemies.first!)
    var backGround: Observable<UIImage>!
    var numberOfEnemy: Observable<Int>!
    let reelStart: Observable<Void>
    var reelActionResults: Observable<[AttributeType]>!
    
    private let attack = PublishRelay<Int64>()
    var playerAttack: Observable<Int64> { return attack.asObservable() }
    
    init(screenTaped: Observable<Bool>, reelStoped: Observable<[AttributeType]>, battleModel: BattleModelProtocol) {
        self.battleModel = battleModel

        self.reelStart = screenTaped.filter{ !$0 }.map{_ in }.throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance)
        
        self.battleModel.userParameter.subscribe(onNext: { [weak self] param in
            self?.userParameter = param
            }).disposed(by: disposeBag)
        
        self.battleModel.currentStage.subscribe(onNext: { [weak self] stage in
            self?.stage = stage
        }).disposed(by: disposeBag)
        
        self.reelActionResults = screenTaped.filter{ $0 }.map{ [unowned self] _ in
            [Probability](repeating: self.enemy.probability, count: self.reelLine.numberOfCharacter).map{prob in prob.randomElement() }
        }.throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance)
        
        reelStoped.subscribe(onNext: { [weak self] results in
            self?.acceptAttack(results: results)
        }).disposed(by: disposeBag)
    }
    
    private func acceptAttack(results: [AttributeType]) {
        // TODO: ダメージ計算ロジック
        let attackPower = results.map{ [unowned self] result in
            self.userParameter.attackPower(of: result)
        }.reduce(0) { $0 + $1 }
        self.attack.accept(attackPower)
    }
}
