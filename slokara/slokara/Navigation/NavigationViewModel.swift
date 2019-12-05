import RxSwift
import RxCocoa

final class NavigationViewModel {
    private let navigationModel: NavigationModelProtocol
    private let disposeBag = DisposeBag()
    
    let hpProgress = BehaviorRelay<Float>(value: 0)
    let currentHp = BehaviorRelay<Int>(value: 0)
    let maxHp = BehaviorRelay<Int>(value: 1)
    let currentCions = BehaviorRelay<Int>(value: 0)
    let currentCredit = BehaviorRelay<Int>(value: 0)
    let currentRank = BehaviorRelay<Int>(value: 1)
    let currentGrade = BehaviorRelay<Grade>(value: .wood)
    
    let transtionBack: Observable<Void>
    
    init(backButtonTapped: Observable<Void>, navigationModel: NavigationModelProtocol = NavigationModelImpl()) {
        self.navigationModel = navigationModel
        self.transtionBack = backButtonTapped
            .throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance)
        
        self.navigationModel.numberOfCoins.subscribe(onNext: { [weak self] num in
            self?.currentCions.accept(num)
        }).disposed(by: disposeBag)
        self.navigationModel.numberOfCredit.subscribe(onNext: { [weak self] num in
            self?.currentCredit.accept(num)
        }).disposed(by: disposeBag)
        self.navigationModel.grade.subscribe(onNext: { [weak self] grade in
            self?.currentGrade.accept(grade)
        }).disposed(by: disposeBag)
        self.navigationModel.rankValue.subscribe(onNext: { [weak self] rankValue in
            self?.currentRank.accept(rankValue)
        }).disposed(by: disposeBag)
        Observable.zip(self.navigationModel.maxHp, self.navigationModel.currentHp).subscribe(onNext: { [weak self] max, current in
            self?.hpProgress.accept(Float(current) / Float(max))
            self?.currentHp.accept(current)
            self?.maxHp.accept(max)
        }).disposed(by: disposeBag)
    }
}
