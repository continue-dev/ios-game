import UIKit
import RxSwift

class AlertView: UIView {
    @IBOutlet private weak var messageLabel: CommonFontLabel!
    @IBOutlet private weak var negativeButton: BorderedButton!
    @IBOutlet private weak var positiveButton: BorderedButton!
    
    private var positiveAction: (() -> Void)?
    private var negativeAction: (() -> Void)?
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        guard let view = Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
        positiveButton.buttonTapped.subscribe({ [weak self] _ in
            self?.positiveAction?()
        }).disposed(by: disposeBag)
        negativeButton.buttonTapped.subscribe({ [weak self] _ in
            self?.negativeAction?()
        }).disposed(by: disposeBag)
    }
    
    func setMessage(_ message: String) {
        messageLabel.text = message
    }
    
    func addAction(action: AlertAction) {
        switch action.style {
        case .positive:
            positiveButton.titleLabel?.text = action.title
            positiveAction = action.handler
        case .negative:
            negativeButton.titleLabel?.text = action.title
            negativeAction = action.handler
        }
    }
}

struct AlertAction {
    let title: String
    let style: Style
    let handler: () -> Void
    
    enum Style {
        case positive
        case negative
    }
}
