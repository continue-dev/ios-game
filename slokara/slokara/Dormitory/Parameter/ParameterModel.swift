import RxSwift

protocol ParameterModelProtocol {
    var userParameter: Observable<UserParameter> { get }
    var gainedExp: Observable<Int64> { get }
}

final class ParameterModelImpl: ParameterModelProtocol {
    
    var userParameter: Observable<UserParameter> {
        return Observable.just(UserParameter(fireAttack: 5, waterAttack: 5, windAttack: 5, soilAttack: 5, lightAttack: 5, darknessAttack: 10, maxHp: 100, defenseType: []))
    }
    
    var gainedExp: Observable<Int64> {
        return Observable.just(100)
    }
}
