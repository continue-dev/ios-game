import RxSwift
import RxCocoa

final class ParameterViewModel {
    private let model: ParameterModelProtocol
    private let disposeBag = DisposeBag()
    
    private lazy var totalExpRelay = BehaviorRelay<Int64>(value: self.editParameters.map{ $0.baseValue }.reduce(0){ $0 + $1 })
    var totalExpObserver: Observable<Int64> {
        return totalExpRelay.asObservable()
    }
    
    private lazy var distributeExpRelay = BehaviorRelay<Int64>(value: self.distributeExp)
    var distributeExpObserver: Observable<Int64> {
        return distributeExpRelay.asObservable()
    }

    
    private lazy var parametersRelay = BehaviorRelay<[EditParameter]>(value: self.editParameters)
    var parameterObserver: Observable<[EditParameter]> {
        return parametersRelay.asObservable()
    }

    private lazy var editingTypeRelay = BehaviorRelay<EditingType>(value: .enter)
    var editingTypeObserver: Observable<EditingType> {
        return editingTypeRelay.asObservable()
    }
    
    private lazy var scrollOffsetRelay = PublishRelay<Int>()
    var scrollOffset: Observable<Int> {
        return scrollOffsetRelay.asObservable()
    }
    
    private var editingType: EditingType = .enter {
        didSet { self.editingTypeRelay.accept(editingType) }
    }
    
    private var editParameters: [EditParameter]! {
        didSet {
            self.parametersRelay.accept(editParameters)
            let totalExp = editParameters.map{ $0.baseValue + $0.addValur }.reduce(0){ $0 + $1 }
            self.totalExpRelay.accept(totalExp)
        }
    }
    
    private var distributeExp: Int64 = 0 {
        didSet { self.distributeExpRelay.accept(distributeExp) }
    }
        
    init(operationScrolled: Observable<Int>, operationTapped: Observable<EditingType>, plusButtonTapped: Observable<Void>, parameterModel: ParameterModelProtocol = ParameterModelImpl()) {
        self.model = parameterModel
        
        self.model.gainedExp.subscribe(onNext: { [weak self] value in
            self?.distributeExp = Int64(value)
        }).disposed(by: disposeBag)
        
        self.model.userParameter.map { param in
                    [EditParameter(type: .hp, baseValue: param.maxHp, addValur: 0),
                     EditParameter(type: .fire, baseValue: param.fireAttack, addValur: 0),
                     EditParameter(type: .water, baseValue: param.waterAttack, addValur: 0),
                     EditParameter(type: .wind, baseValue: param.windAttack, addValur: 0),
                     EditParameter(type: .soil, baseValue: param.soilAttack, addValur: 0),
                     EditParameter(type: .light, baseValue: param.lightAttack, addValur: 0),
                     EditParameter(type: .darkness, baseValue: param.darknessAttack, addValur: 0)]
        }.subscribe(onNext: { [weak self] editParams in
            self?.editParameters = editParams
        }).disposed(by: disposeBag)
                
        operationScrolled.map{ EditingType.allCases[$0] }.subscribe(onNext: { [weak self] type in
            self?.editingType = type
        }).disposed(by: disposeBag)
        
        operationTapped.subscribe(onNext: { [weak self] type in
            let current = self?.editingType == type ? .enter : type
            self?.editingType = current
            self?.scrollOffsetRelay.accept(current.rawValue)
        }).disposed(by: disposeBag)
        
        plusButtonTapped.subscribe(onNext: { [weak self] _ in
            self?.parameterPlus(type: self?.editingType)
        }).disposed(by: disposeBag)
    }
    
    private func parameterPlus(type: EditingType?) {
        guard let type = type else { return }
        guard self.distributeExp > 0 else { return }
        self.distributeExp -= 1
        self.editParameters[EditParamType(editingType: type).rawValue].addValur += 1
        
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
