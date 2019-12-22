import UIKit
import RxSwift
import RxCocoa

class NavigationViewController: UIViewController {

    @IBOutlet private weak var container: UIView!
    @IBOutlet private weak var topSpacer: UIView!
    @IBOutlet private weak var hpProgressView: UIProgressView!
    @IBOutlet private weak var rankNumberLabel: BorderedLabel!
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var gradeLabel: BorderedLabel!
    @IBOutlet private weak var titleLabel: CommonFontLabel!
    @IBOutlet private weak var creditLabel: CommonFontLabel!
    @IBOutlet private weak var coinLabel: CommonFontLabel!
    @IBOutlet private weak var hpLabel: CommonFontLabel!
    @IBOutlet private weak var emblemImageView: UIImageView!
    @IBOutlet private weak var backButton: UIButton!
    
    weak var currentViewController: NavigationChildViewController? {
        return navigationChildViewControllers.last
    }
    private(set) weak var rootViewController: NavigationChildViewController! {
        didSet{
            navigationChildViewControllers.append(rootViewController)
        }
    }
    private(set) var navigationChildViewControllers = [NavigationChildViewController]() {
        didSet{
            _navigationChildViewControllers.accept(navigationChildViewControllers)
        }
    }
    
    private lazy var viewModel = NavigationViewModel(backButtonTapped: backButton.rx.tap.asObservable())
    private lazy var _navigationChildViewControllers = BehaviorRelay(value: navigationChildViewControllers)
    private let dispodeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setUp()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        topSpacer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.safeAreaInsets.top)
        applyRootTopSpacer()
        applyGradientColor(view: topSpacer)
    }
    
    private func setUp() {
        topSpacer.translatesAutoresizingMaskIntoConstraints = true
        add(rootViewController)
        gradeLabel.setFont(.logoTypeGothic)
    }
    
    private func bind() {
        viewModel.hpProgress
            .bind(to: hpProgressView.rx.progress)
            .disposed(by: dispodeBag)
        
        BehaviorRelay.zip(viewModel.currentHp, viewModel.maxHp)
            .map { "\($0)/\($1)" }
            .bind(to: hpLabel.rx.text)
            .disposed(by: dispodeBag)
        
        viewModel.currentCions
            .map{ String($0) }
            .bind(to: coinLabel.rx.text)
            .disposed(by: dispodeBag)
        
        viewModel.currentCredit
            .map{ String($0) }
            .bind(to: creditLabel.rx.text)
            .disposed(by: dispodeBag)
        
        viewModel.currentRank
            .map{ String($0) }
            .bind(to: rankNumberLabel.rx.text)
            .disposed(by: dispodeBag)
        
        viewModel.currentGrade
            .map{ $0.name }
            .bind(to: gradeLabel.rx.text)
            .disposed(by: dispodeBag)
        
        viewModel.currentGrade
            .map{ $0.emblemImage }
            .bind(to: emblemImageView.rx.image)
            .disposed(by: dispodeBag)
        
        viewModel.currentGrade
            .map{ $0.textBorderColor }
            .bind(to: gradeLabel.borderColor)
            .disposed(by: dispodeBag)
        
        viewModel.currentGrade
            .map{ $0.textBorderColor }
            .bind(to: rankNumberLabel.borderColor)
            .disposed(by: dispodeBag)
        
        viewModel.transtionBack
            .bind(to: transitionToBack)
            .disposed(by: dispodeBag)
        
        _navigationChildViewControllers
            .map{ $0.count < 2 }
            .bind(to: backButton.rx.isHidden)
            .disposed(by: dispodeBag)
        
        _navigationChildViewControllers
            .map{ $0.last?.title == nil }
            .bind(to: titleView.rx.isHidden)
            .disposed(by: dispodeBag)
        
        _navigationChildViewControllers
            .map{ $0.last?.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: dispodeBag)
    }
    
    func push(_ viewController: NavigationChildViewController, animate: Bool) {
        guard let current = currentViewController else { return }
        navigationChildViewControllers.append(viewController)
        
        addChild(viewController)
        viewController.view.frame = self.container.frame
        self.container.addSubview(viewController.view)
        
        if animate {
            transition(from: current,
                       to: viewController,
                       duration: 0.3,
                       options: .transitionCrossDissolve,
                       animations: nil) { [weak self] _ in
                viewController.didMove(toParent: self)
            }
        } else {
            viewController.didMove(toParent: self)
        }
        
        let topFrame = CGRect(x: 0, y: 0, width: topSpacer.bounds.width, height: backButton.frame.maxY)
        viewController.applyTopSpacer(frame: topFrame)
    }
    
    func popViewController(animate: Bool) {
        guard let current = currentViewController else { return }
        guard navigationChildViewControllers.count >= 2 else { return }
        let previous = navigationChildViewControllers[navigationChildViewControllers.count - 2]
        navigationChildViewControllers.removeLast()
        
        addChild(previous)
        previous.view.frame = self.container.frame
        self.container.addSubview(previous.view)
        
        if animate {
            transition(from: current,
                       to: previous,
                       duration: 0.3,
                       options: .transitionCrossDissolve,
                       animations: nil) { [weak self] _ in
                current.willMove(toParent: nil)
                current.view.removeFromSuperview()
                current.removeFromParent()
                previous.didMove(toParent: self)
            }
        } else {
            current.willMove(toParent: nil)
            current.view.removeFromSuperview()
            current.removeFromParent()
            previous.didMove(toParent: self)
        }
    }
    
    private func add(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = self.container.frame
        self.container.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}

extension NavigationViewController {
    // 初期化用メソッド
    static func instantiate(rootViewController: NavigationChildViewController) -> NavigationViewController {
        let navigationController = UIStoryboard(name: "Navigation", bundle: nil).instantiateInitialViewController() as! NavigationViewController
        navigationController.rootViewController = rootViewController
        return navigationController
    }
    
    private func applyGradientColor(view: UIView) {
        let topColor = UIColor(red: 18.0/256, green: 15.0/256, blue: 10.0/256, alpha: 1)
        let bottomColor = UIColor(red: 68.0/256, green: 63.0/256, blue: 52.0/256, alpha: 1)
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.frame = view.bounds

        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func applyRootTopSpacer() {
        let topFrame = CGRect(x: 0, y: 0, width: topSpacer.bounds.width, height: backButton.frame.maxY)
        rootViewController.applyTopSpacer(frame: topFrame)
    }
    
    private var transitionToBack: Binder<Void> {
        return Binder(self) { me, _ in
            me.popViewController(animate: true)
        }
    }
}
