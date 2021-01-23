import Foundation
import RxSwift

final class ReelShopViewModel {
    private let model: ReelShopModelProtocol
    private let disposeBag = DisposeBag()
    
    // リール購入ベース価格
    private let reelPrice = 500
    
    var currentCoins: Observable<Int>
    private let paymentCoinsRelay = BehaviorSubject(value: 0)
    var paymentCoins: Observable<Int> {
        return paymentCoinsRelay.asObservable()
    }
    
    var currentReel: Observable<Reel>
    
    init(reelStatus: Observable<[[ReelStatusView.ShopReelStatus]]>, enterButtonTapped: Observable<Void>, reelShopModel: ReelShopModelProtocol = ReelShopModelImpl()) {
        model = reelShopModel
        
        currentCoins = model.currentCoins
        currentReel = model.currentReel
        reelStatus.subscribe(onNext: { [unowned self] status in
            let selectedCount = status.flatMap { $0 }.filter { $0 == .selected }.count
            let price = reelPrice * (0...selectedCount).reduce(0) { $0 + $1 }
            paymentCoinsRelay.onNext(price)
        }).disposed(by: disposeBag)
        
        enterButtonTapped.withLatestFrom(reelStatus).subscribe(onNext: { [unowned self] status in
            let newReel = Reel(top: [checkEnableReel(state: status[0][0]), checkEnableReel(state: status[0][1]), checkEnableReel(state: status[0][2])],
                               center: [checkEnableReel(state: status[1][0]), checkEnableReel(state: status[1][1]), checkEnableReel(state: status[1][2])],
                               bottom: [checkEnableReel(state: status[2][0]), checkEnableReel(state: status[2][1]), checkEnableReel(state: status[2][2])])
            model.saveFutureReel(newReel)
        }).disposed(by: disposeBag)
        
        let coins = Observable.combineLatest(currentCoins, paymentCoins)
        enterButtonTapped.withLatestFrom(coins).subscribe(onNext: { [unowned self] current, payment in
            let futureCoins = current - payment
            model.saveFutureCoins(futureCoins)
        }).disposed(by: disposeBag)
    }
    
    private func checkEnableReel(state: ReelStatusView.ShopReelStatus) -> Bool {
        switch state {
        case .hold(_), .selected:
            return true
        default:
            return false
        }
    }
 }
