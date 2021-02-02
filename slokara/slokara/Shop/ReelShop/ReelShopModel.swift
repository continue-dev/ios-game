import Foundation
import RxSwift
import RealmSwift

protocol ReelShopModelProtocol {
    var currentCoins: Observable<Int> { get }
    var currentReel: Observable<Reel> { get }
    func saveFutureCoins(_ coins: Int)
    func saveFutureReel(_ reel: Reel)
}

final class ReelShopModelImpl: ReelShopModelProtocol {
    private var status: UserStatus!
    private var reel: ReelStatus!

    var currentCoins: Observable<Int> {
        guard let realm = try? Realm() else { assert(false, "Realmをインスタンス化できませんでした") }
        guard let status = realm.objects(UserStatus.self).first else { assert(false, "ユーザーステータスを取得できませんでした") }
        self.status = status
        
        #if !PROD
        if UserDefaults.standard.bool(forKey: "tuningMode") {
            self.status = realm.objects(UserStatus.self)[1]
        }
        #endif
        
        return Observable.just(self.status.numberOfCoins)
    }
    
    var currentReel: Observable<Reel> {
        guard let realm = try? Realm() else { assert(false, "Realmをインスタンス化できませんでした") }

        #if !PROD
        if UserDefaults.standard.bool(forKey: "tuningMode") {
            let debugReel = realm.objects(ReelStatus.self)[1]
            self.reel = debugReel
            return Observable.just(Reel(object: debugReel))
        }
        #endif
        guard let reel = realm.objects(ReelStatus.self).first else { assert(false, "リールステータスを取得できませんでした") }
        self.reel = reel
        return Observable.just(Reel(object: reel))
    }
    
    func saveFutureCoins(_ coins: Int) {
        guard let realm = try? Realm() else { assert(false, "Realmをインスタンス化できませんでした") }
        try! realm.write {
            status.numberOfCoins = coins
        }
    }
    
    func saveFutureReel(_ reel: Reel) {        
        guard let realm = try? Realm() else { assert(false, "Realmをインスタンス化できませんでした") }
        try! realm.write {
            self.reel.topLeft = reel.top[0]
            self.reel.topCenter = reel.top[1]
            self.reel.topRight = reel.top[2]
            self.reel.middleLeft = reel.center[0]
            self.reel.middleCenter = reel.center[1]
            self.reel.middleRight = reel.center[2]
            self.reel.bottomLeft = reel.bottom[0]
            self.reel.bottomCenter = reel.bottom[1]
            self.reel.bottomRight = reel.bottom[2]
        }
    }
}
