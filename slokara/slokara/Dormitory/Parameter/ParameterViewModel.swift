import RxSwift
import RxCocoa

final class ParameterViewModel {
    private let model: ParameterModelProtocol
    private let disposeBag = DisposeBag()
    
    let parametrts: Observable<[(type: ParameterType, value: Int64)]>
    let distributeExp: Observable<Int>
    
    init(parameterModel: ParameterModelProtocol = ParameterModelImpl()) {
        self.model = parameterModel
        
        self.parametrts = self.model.userParameter.map { param in
            [(ParameterType.hp, param.maxHp),
             (ParameterType.attribute(type: .fire), param.fireAttack),
             (ParameterType.attribute(type: .water), param.waterAttack),
             (ParameterType.attribute(type: .wind), param.windAttack),
             (ParameterType.attribute(type: .soil), param.soilAttack),
             (ParameterType.attribute(type: .light), param.lightAttack),
             (ParameterType.attribute(type: .darkness), param.darknessAttack)]
        }
        
        self.distributeExp = self.model.gainedExp
    }
}
