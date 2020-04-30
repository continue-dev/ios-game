import UIKit
import RxSwift
import RxCocoa

class ToggleAttributeImageView: UIImageView {
    private var attribute: AttributeType! {
        didSet{ self.image = attribute.image }
    }
    
    var isSelected: Bool = false {
        didSet{ self.alpha = isSelected ? 1 : 0.3 }
    }
    
    private let selectEvent = PublishRelay<Bool>()
    var didTap: Observable<Bool> { return selectEvent.asObservable() }
    
    func setAttribute(attribute: AttributeType) {
        self.attribute = attribute
        self.alpha = 0.3
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isSelected.toggle()
        self.selectEvent.accept(self.isSelected)
    }
}
