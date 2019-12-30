import UIKit

class AlertView: UIView {
    @IBOutlet private weak var messageLabel: CommonFontLabel!
    @IBOutlet private weak var negativeButton: BorderedButton!
    @IBOutlet private weak var positiveButton: BorderedButton!
    
    private var positiveAction: (() -> Void)?
    private var negativeAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
    
    private func loadNib() {
        guard let view = Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }
    
    @IBAction private func positiveButtonTapped(_ sender: Any) {
        positiveAction?()
    }
    
    @IBAction private func negativeButtonTapped(_ sender: Any) {
        negativeAction?()
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
