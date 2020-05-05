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
        
        #if !PROD
        if UserDefaults.standard.bool(forKey: "tuningMode"), let data = UserDefaults.standard.data(forKey: "userParameter") {
            guard let param =  try? JSONDecoder().decode(UserParameter.self, from: data) else { fatalError("UserParameter decode failed.") }
            self.baseParam = param
        }
        #endif
        return Observable.just(self.baseParam!)
    }
    
    var gainedExp: Observable<Int64> {
        #if !PROD
        if UserDefaults.standard.bool(forKey: "tuningMode") {
            return Observable.just(9999)
        }
        #endif
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
        #if !PROD
        if UserDefaults.standard.bool(forKey: "tuningMode") {
            guard let json = try? JSONEncoder().encode(editedParam) else { fatalError("UserParameter encode failed.") }
            UserDefaults.standard.set(json, forKey: "userParameter")
        }
        #endif
    }
}
