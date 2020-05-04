import RxSwift
import RxCocoa

final class ParameterViewModel {
    private let model: ParameterModelProtocol
    private let disposeBag = DisposeBag()
    
    let parametrts: Observable<[(type: ParameterType, value: Int64)]>
    let distributeExp: Observable<Int>
    let editingType: Observable<EditingType>
    
    init(operationScrolled: Observable<Int>, parameterModel: ParameterModelProtocol = ParameterModelImpl()) {
        self.model = parameterModel
        
        self.editingType = operationScrolled.map { EditingType.allCases[$0] }
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

enum EditingType: Int, CaseIterable {
    case enter
    case hp
    case fire
    case water
    case wind
    case soil
    case light
    case darkness
    
    init(parameterType: ParameterType) {
        switch parameterType {
        case .hp:
            self = .hp
        case .attribute(let type):
            switch type {
            case .fire:
                self = .fire
            case .water:
                self = .water
            case .wind:
                self = .wind
            case .soil:
                self = .soil
            case .light:
                self = .light
            case .darkness:
                self = .darkness
            default:
                self = .enter
            }
        }
    }
}
