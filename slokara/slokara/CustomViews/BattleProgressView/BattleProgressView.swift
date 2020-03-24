import UIKit

class BattleProgressView: UIView {
    
    @IBOutlet private weak var baseStackView: UIStackView!
    @IBOutlet private weak var baseBarView: UIView!
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var pointStackView: UIStackView!
    
    private var progressPoints = [UIView]()
    
    var progressMax = 1 {
        didSet { createProgress() }
    }
    
    private var currentStep = 0 {
        didSet { advanceProgress() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func nextStep() {
        guard self.currentStep < self.progressMax - 1 else { return }
        self.currentStep += 1
    }
}

extension BattleProgressView {
    private func setUp() {
        guard let view = Bundle.main.loadNibNamed("BattleProgressView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        self.backgroundColor = .clear
        addSubview(view)
    }
    
    private func createProgress() {
        guard self.progressMax > 1 else { self.isHidden = true; return }
        
        (0..<self.progressMax).forEach { [weak self] _ in
            let baseBox = UIView(frame: .zero)
            baseBox.backgroundColor = self?.baseBarView.backgroundColor
            self?.baseStackView.addArrangedSubview(baseBox)
            baseBox.translatesAutoresizingMaskIntoConstraints = false
            baseBox.heightAnchor.constraint(equalTo: baseBox.widthAnchor).isActive = true
            baseBox.transform = CGAffineTransform(rotationAngle: 45 * .pi / 180)
        }
        
        self.progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.progressBar.widthAnchor.constraint(equalTo: self.baseBarView.heightAnchor, constant: -8).isActive = true
        self.progressBar.heightAnchor.constraint(equalTo: self.baseBarView.widthAnchor, constant: -6).isActive = true
        self.progressBar.transform = CGAffineTransform(rotationAngle: -90 * .pi / 180)
        
        self.baseStackView.subviews.forEach { [weak self] v in
            let pointView = UIView(frame: v.frame)
            pointView.backgroundColor = .black
            self?.pointStackView.addArrangedSubview(pointView)
            pointView.translatesAutoresizingMaskIntoConstraints = false
            pointView.heightAnchor.constraint(equalTo: pointView.widthAnchor).isActive = true
            pointView.transform = CGAffineTransform(rotationAngle: 45 * .pi / 180)
            self?.progressPoints.insert(pointView, at: 0)
        }
        
        self.progressPoints.first?.backgroundColor = .white
    }
    
    private func advanceProgress() {
        self.progressBar.setProgress(Float(self.currentStep) / Float(self.progressMax - 1), animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.progressPoints[self.currentStep].backgroundColor = .white
        }
    }
}
