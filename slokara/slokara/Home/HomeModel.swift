import Foundation
import RxSwift

protocol HomeModelProtocol {
    var maxHp: Observable<Int> { get }
    var currentHp: Observable<Int> { get }
    var numberOfCoins: Observable<Int> { get }
    var numberOfTani: Observable<Int> { get }
    var gradeName: Observable<String> { get }
    var rankValue: Observable<Int>{ get }
}

final class HomeModelImpl: HomeModelProtocol {
    var maxHp: Observable<Int> {
        return Observable.just(100)
    }
    
    var currentHp: Observable<Int> {
        return Observable.just(70)
    }
    
    var numberOfCoins: Observable<Int> {
        return Observable.just(567)
    }
    
    var numberOfTani: Observable<Int> {
        return Observable.just(99)
    }
    
    var gradeName: Observable<String> {
        return Observable.just("中等部")
    }
    
    var rankValue: Observable<Int> {
        return Observable.just(2)
    }
}
