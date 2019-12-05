import RxSwift
import RxCocoa

final class HomeViewModel {
    private let homeModel: HomeModelProtocol
    private let disposeBag = DisposeBag()
    
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
    }
}
