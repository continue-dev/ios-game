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
    
    init(reelStatus: Observable<[[ReelStatusView.ShopReelStatus]]>, reelShopModel: ReelShopModelProtocol = ReelShopModelImpl()) {
        model = reelShopModel
        
        currentCoins = model.currentCoins
        currentReel = model.currentReel
        reelStatus.subscribe(onNext: { [unowned self] status in
            let selectedCount = status.flatMap { $0 }.filter { $0 == .selected }.count
            let price = reelPrice * (0...selectedCount).reduce(0) { $0 + $1 }
            paymentCoinsRelay.onNext(price)
        }).disposed(by: disposeBag)
    }
}
