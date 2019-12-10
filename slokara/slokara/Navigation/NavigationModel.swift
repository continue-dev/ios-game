import Foundation
import RxSwift

protocol NavigationModelProtocol {
    var maxHp: Observable<Int> { get }
    var currentHp: Observable<Int> { get }
    var numberOfCoins: Observable<Int> { get }
    var numberOfCredit: Observable<Int> { get }
    var grade: Observable<Grade> { get }
    var rankValue: Observable<Int>{ get }
}

final class NavigationModelImpl: NavigationModelProtocol {
    var maxHp: Observable<Int> {
        return Observable.just(100)
    }
    
    var currentHp: Observable<Int> {
        return Observable.just(70)
    }
    
    var numberOfCoins: Observable<Int> {
        return Observable.just(567)
    }
    
    var numberOfCredit: Observable<Int> {
        return Observable.just(99)
    }
    
    var grade: Observable<Grade> {
        return Observable.just(.copper)
    }
    
    var rankValue: Observable<Int> {
        return Observable.just(2)
    }
}
