import RxSwift
import RxCocoa

final class HomeViewModel {
    private let homeModel: HomeModelProtocol
    private let disposeBag = DisposeBag()
    
    let hpProgress = BehaviorRelay<Float>(value: 0)
    let currentCions = BehaviorRelay<Int>(value: 0)
    let currentTani = BehaviorRelay<Int>(value: 0)
    let currentRank = BehaviorRelay<Int>(value: 1)
    let currentGrade = BehaviorRelay<String>(value: "幼等部")
    
    let transitionToFinalButtle: Observable<Void>
    let transitionToBossButtle: Observable<Void>
    let transitionToStatus: Observable<Void>
    let transitionToShop: Observable<Void>
    let transitionToItems: Observable<Void>
    let transitionToTask: Observable<Void>
    
    init(kochoButtonTapped: Observable<Void>,
         kodoButtonTapped: Observable<Void>,
         ryoButtonTapped: Observable<Void>,
         shopButtonTapped: Observable<Void>,
         lockerButtonTapped: Observable<Void>,
         roomButtonTapped: Observable<Void>,
         homeModel: HomeModelProtocol = HomeModelImpl()) {
        
        self.homeModel = homeModel
        
        self.transitionToFinalButtle = kochoButtonTapped
            .throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance)
        self.transitionToBossButtle = kodoButtonTapped
            .throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance)
        self.transitionToStatus = ryoButtonTapped
            .throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance)
        self.transitionToShop = shopButtonTapped
            .throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance)
        self.transitionToItems = lockerButtonTapped
            .throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance)
        self.transitionToTask = roomButtonTapped
            .throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance)
        
        self.homeModel.numberOfCoins.subscribe(onNext: { [weak self] num in
            self?.currentCions.accept(num)
        }).disposed(by: disposeBag)
        self.homeModel.numberOfTani.subscribe(onNext: { [weak self] num in
            self?.currentTani.accept(num)
            }).disposed(by: disposeBag)
        self.homeModel.gradeName.subscribe(onNext: { [weak self] gradeName in
            self?.currentGrade.accept(gradeName)
            }).disposed(by: disposeBag)
        self.homeModel.rankValue.subscribe(onNext: { [weak self] rankValue in
            self?.currentRank.accept(rankValue)
            }).disposed(by: disposeBag)
        Observable.zip(self.homeModel.maxHp, self.homeModel.currentHp).subscribe(onNext: { [weak self] max, current in
            self?.hpProgress.accept(Float(current) / Float(max))
            }).disposed(by: disposeBag)
        }
}
