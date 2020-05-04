import RxSwift

protocol ParameterModelProtocol {
    var userParameter: Observable<UserParameter> { get }
    var gainedExp: Observable<Int64> { get }
    func saveParameter(params: [EditParameter])
}

final class ParameterModelImpl: ParameterModelProtocol {
    
    private var baseParam: UserParameter?
    
    var userParameter: Observable<UserParameter> {
        self.baseParam = UserParameter(fireAttack: 5, waterAttack: 5, windAttack: 5, soilAttack: 5, lightAttack: 5, darknessAttack: 10, maxHp: 100, defenseType: [])
        return Observable.just(self.baseParam!)
    }
    
    var gainedExp: Observable<Int64> {
        return Observable.just(100)
    }
    
    func saveParameter(params: [EditParameter]) {
        let difenseTypes = self.baseParam?.defenseType ?? []
        let editedParam = UserParameter(fireAttack: params.first(where: {$0.type == .fire})!.totalValue,
                                  waterAttack: params.first(where: {$0.type == .water})!.totalValue,
                                  windAttack: params.first(where: {$0.type == .wind})!.totalValue,
                                  soilAttack: params.first(where: {$0.type == .soil})!.totalValue,
                                  lightAttack: params.first(where: {$0.type == .light})!.totalValue,
                                  darknessAttack: params.first(where: {$0.type == .darkness})!.totalValue,
                                  maxHp: params.first(where: {$0.type == .hp})!.totalValue,
                                  defenseType: difenseTypes)
        // TODO: セーブ処理
        print("newParam:\(editedParam)")
    }
}
