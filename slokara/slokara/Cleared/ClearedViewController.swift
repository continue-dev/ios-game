import UIKit
import RxSwift
import RxCocoa

class ClearedViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet private weak var taskCellView: TaskCellView!
    @IBOutlet weak var stampView: UIView!
    @IBOutlet weak var stampRingView: UIImageView!
    
    private let disposeBag = DisposeBag()
    var task: Task?
    
    private let endStampRelay = PublishRelay<Void>()
    private let addCoinsRelay = PublishRelay<Int>()
    private let addCreditsRelay = PublishRelay<Int>()
    
    private lazy var viewModel = ClearedViewModel(endStampAnimation: self.endStampRelay.asObservable(), addCoins: self.addCoinsRelay.asObservable(), addCredits: self.addCreditsRelay.asObservable(), clearedModel: ClearedModelImpl(taskId: self.task!))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = false
        (self.parent as? NavigationViewController)?.backButtonIsHidden(true)
        if let task = self.task {
            self.taskCellView.setTask(task)
        }
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let task = self.task else { return }
        if task.isPassed {
            updateStatus()
        } else {
            rotateRing()
            animToAlfaMax()
        }
    }
    
    private func bind() {
        viewModel.task.subscribe(onNext: { _ in
            
        }).disposed(by: disposeBag)
    }
    
    private func animToAlfaMax() {
        UIView.animate(withDuration: 0.7, delay: 0.7, options: .curveEaseIn, animations: { [weak self] in
            self?.stampView.alpha = 1
        }) { [weak self] (_) in
            self?.animToTransition()
        }
    }
    
    private func animToTransition() {
        self.stampView.translatesAutoresizingMaskIntoConstraints = true
        let rotate = CGAffineTransform(rotationAngle: -15 * .pi / 180)
        let transition = CGAffineTransform(translationX: self.view.bounds.width / 5, y: self.taskCellView.center.y - self.stampView.center.y)
        let transform = CGAffineTransform(scaleX: 0.38, y: 0.38).concatenating(rotate).concatenating(transition)
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: { [weak self] in
            self?.stampView.transform = transform
        }) { [unowned self] (_) in
            self.task?.isPassed = true
            self.taskCellView.setTask(self.task!)
            self.stampView.alpha = 0
            self.animVibration()
        }
    }
    
    private func animVibration() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .autoreverse, animations: { [weak self] in
            self?.taskCellView.transform = CGAffineTransform(translationX: 1, y: 4)
        }) { [weak self] (_) in
            self?.updateStatus()
        }
    }
    
    private func updateStatus() {
        self.endStampRelay.accept(())
        self.addCoinsRelay.accept(self.task?.rewardCoins ?? 0)
        self.addCreditsRelay.accept(self.task?.rewardCredits ?? 0)
        self.view.isUserInteractionEnabled = true
    }
    
    private func rotateRing() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0.0
        animation.toValue = CGFloat(.pi * 2.0)
        animation.duration = 8.0
        animation.repeatCount = .infinity
        self.stampRingView.layer.add(animation, forKey: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.isUserInteractionEnabled = false
        (self.parent as? NavigationViewController)?.popRootViewController(animate: true)
    }
}
