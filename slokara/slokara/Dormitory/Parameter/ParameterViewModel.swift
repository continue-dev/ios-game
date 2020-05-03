import RxSwift
import RxCocoa

final class ParameterViewModel {
    private let model: ParameterModelProtocol
    private let disposeBag = DisposeBag()
    
//    private let parameterRelay = PublishRelay<[(type: ParameterType, value: Int64)]>()
    let parametrts: Observable<[(type: ParameterType, value: Int64)]> //{
//        return parameterRelay.asObservable()
//    }
    
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
//        self.model.userParameter.subscribe(onNext: { [weak self] param in
//            print("これだよ:\(param)")
//            let parameters: [(ParameterType, Int64)] = [(.hp, param.maxHp),
//                                                        (.attribute(type: .fire), param.fireAttack),
//                                                        (.attribute(type: .water), param.waterAttack),
//                                                        (.attribute(type: .wind), param.windAttack),
//                                                        (.attribute(type: .soil), param.soilAttack),
//                                                        (.attribute(type: .light), param.lightAttack),
//                                                        (.attribute(type: .darkness), param.darknessAttack)]
//            print("これかな:\(parameters)")
//            self!.parameterRelay.accept(parameters)
//        }).disposed(by: disposeBag)
    }
}
