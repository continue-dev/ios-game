import RxSwift
import RxCocoa

final class ClearedViewModel {
    private let clearedModel: ClearedModelProtocol
    private let disposeBag = DisposeBag()
    
    private let taskRelay = PublishRelay<Task>()
    var task: Observable<Task> { return self.taskRelay.asObservable() }
    
    init(endStampAnimation: Observable<Void>, addCoins: Observable<Int>, addCredits: Observable<Int>, clearedModel: ClearedModelProtocol) {
        self.clearedModel = clearedModel
        
        endStampAnimation.subscribe(onNext: { [weak self] _ in
            self?.clearedModel.fullRecoveryHP()
        }).disposed(by: disposeBag)
        
        addCoins.subscribe(onNext: { [weak self] value in
            self?.clearedModel.addCoins(coins: value)
        }).disposed(by: disposeBag)
        
        addCredits.subscribe(onNext: { [weak self] value in
            self?.clearedModel.addCredits(credits: value)
        }).disposed(by: disposeBag)
    }
}
