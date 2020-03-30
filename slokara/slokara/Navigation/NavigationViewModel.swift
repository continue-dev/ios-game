import RxSwift
import RxCocoa

final class NavigationViewModel {
    private let navigationModel: NavigationModelProtocol
    private let disposeBag = DisposeBag()
    
    let hpProgress = BehaviorRelay<Float>(value: 0)
    let currentHp = BehaviorRelay<Int64>(value: 0)
    let maxHp = BehaviorRelay<Int64>(value: 1)
    let currentCoins = BehaviorRelay<Int>(value: 0)
    let currentCredit = BehaviorRelay<Int>(value: 0)
    let currentRank = BehaviorRelay<Int>(value: 1)
    let currentGrade = BehaviorRelay<Grade>(value: .wood)
    
    let transtionBack: Observable<Void>
    
    init(backButtonTapped: Observable<Void>, navigationModel: NavigationModelProtocol = NavigationModelImpl()) {
        self.navigationModel = navigationModel
        self.transtionBack = backButtonTapped
            .throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance)
        
        self.navigationModel.status.subscribe(onNext: { [weak self] status in
            self?.hpProgress.accept(Float(status.currentHp) / Float(status.maxHp))
            self?.currentHp.accept(status.currentHp)
            self?.maxHp.accept(status.maxHp)
            self?.currentCoins.accept(status.numberOfCoins)
            self?.currentCredit.accept(status.numberOfCredit)
            self?.currentGrade.accept(status.grade)
            self?.currentRank.accept(status.rankValue)
        }).disposed(by: disposeBag)
    }
}
