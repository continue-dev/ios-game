import UIKit
import RxSwift
import RxCocoa

class ReelCharacter: UIImageView {
    private var currentCharacter: AttributeType? = .light
    private let stoped = PublishRelay<Void>()
    var animationStoped: Observable<Void> { return self.stoped.asObservable() }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        self.image = currentCharacter?.image
        self.animationImages = AttributeType.allCases.map { $0.image }
        self.animationDuration = 0.4
    }
    
    func startAnimation(delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.startAnimating()
        }
        UIView.animate(withDuration: 0.15, delay: delay, options: [.repeat, .autoreverse], animations: { [weak self] in
            self?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }) { [weak self] (_) in
            self?.transform = .identity
        }
    }
    
    func stopAnimation(result: AttributeType, delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.stopAnimating()
            self?.layer.removeAllAnimations()
            self?.image = result.image
            self?.stoped.accept(())
        }
    }
}
