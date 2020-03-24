import RxSwift
import RxCocoa

final class BattleViewModel {
    private let battleModel: BattleModelProtocol
    private let disposeBag = DisposeBag()
    
    private let reelLine = ReelLine.triple
    
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
    var reelStop: Observable<[AttributeType]>!
    
    init(screenTaped: Observable<Bool>, battleModel: BattleModelProtocol) {
        self.battleModel = battleModel

        self.reelStart = screenTaped.filter{ !$0 }.map{_ in }.throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance)
        
        self.battleModel.currentStage.subscribe(onNext: { [weak self] stage in
            self?.stage = stage
        }).disposed(by: disposeBag)
        
        self.reelStop = screenTaped.filter{ $0 }.map{ [unowned self] _ in
            [Probability](repeating: self.enemy.probability, count: self.reelLine.numberOfCharacter).map{prob in prob.randomElement() }
        }.throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance)
        
    }
}
