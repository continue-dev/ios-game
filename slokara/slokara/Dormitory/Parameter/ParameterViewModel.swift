import Foundation

final class ParameterViewModel {
    private let model: ParameterModelProtocol
    
    init(parameterModel: ParameterModelProtocol = ParameterModel()) {
        self.model = parameterModel
    }
}
