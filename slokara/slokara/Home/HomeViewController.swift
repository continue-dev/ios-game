import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    @IBOutlet private weak var hpProgressView: UIProgressView!
    @IBOutlet private weak var coinsLabel: UILabel!
    @IBOutlet private weak var taniLabel: UILabel!
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var gradeLabel: UILabel!
    @IBOutlet private weak var hpLabel: UILabel!
    @IBOutlet private weak var kochoButton: UIButton!
    @IBOutlet private weak var kodoButton: UIButton!
    @IBOutlet private weak var ryoButton: UIButton!
    @IBOutlet private weak var shopButton: UIButton!
    @IBOutlet private weak var lockerButton: UIButton!
    @IBOutlet private weak var roomButton: UIButton!
    
    private lazy var viewModel = HomeViewModel(
        kochoButtonTapped: kochoButton.rx.tap.asObservable(),
        kodoButtonTapped: kodoButton.rx.tap.asObservable(),
        ryoButtonTapped: ryoButton.rx.tap.asObservable(),
        shopButtonTapped: shopButton.rx.tap.asObservable(),
        lockerButtonTapped: lockerButton.rx.tap.asObservable(),
        roomButtonTapped: roomButton.rx.tap.asObservable())
    
    private let dispodeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.hpProgress
            .bind(to: hpProgressView.rx.progress)
            .disposed(by: dispodeBag)
        
        BehaviorRelay.zip(viewModel.currentHp, viewModel.maxHp)
            .map { "HP:\($0)/\($1)" }
            .bind(to: hpLabel.rx.text)
            .disposed(by: dispodeBag)
        
        viewModel.currentCions
            .map{ String($0) }
            .bind(to: coinsLabel.rx.text)
            .disposed(by: dispodeBag)
        
        viewModel.currentTani
            .map{ String($0) }
            .bind(to: taniLabel.rx.text)
            .disposed(by: dispodeBag)
        
        viewModel.currentRank
            .map{ String($0) }
            .bind(to: rankLabel.rx.text)
            .disposed(by: dispodeBag)
        
        viewModel.currentGrade
            .bind(to: gradeLabel.rx.text)
            .disposed(by: dispodeBag)
        
        viewModel.transitionToFinalButtle
            .bind(to: transitionToFinalButtle)
            .disposed(by: dispodeBag)
        
        viewModel.transitionToBossButtle
            .bind(to: transitionToBossButtle)
            .disposed(by: dispodeBag)
        
        viewModel.transitionToShop
            .bind(to: transitionToShop)
            .disposed(by: dispodeBag)
        
        viewModel.transitionToItems
            .bind(to: transitionToItems)
            .disposed(by: dispodeBag)
        
        viewModel.transitionToStatus
            .bind(to: transitionToStatus)
            .disposed(by: dispodeBag)
        
        viewModel.transitionToTask
            .bind(to: transitionToTask)
            .disposed(by: dispodeBag)
    }
}

extension HomeViewController {
    private var transitionToFinalButtle: Binder<Void> {
        return Binder(self) { me, _ in
            // TODO: TransitionToNextScreen
            print("FinalButtle")
        }
    }
    
    private var transitionToBossButtle: Binder<Void> {
        return Binder(self) { me, _ in
            // TODO: TransitionToNextScreen
            print("BossButtle")
        }
    }
    
    private var transitionToStatus: Binder<Void> {
        return Binder(self) { me, _ in
            // TODO: TransitionToNextScreen
            print("Status")
        }
    }
    
    private var transitionToShop: Binder<Void> {
        return Binder(self) { me, _ in
            // TODO: TransitionToNextScreen
            print("Shop")
        }
    }
    
    private var transitionToItems: Binder<Void> {
        return Binder(self) { me, _ in
            // TODO: TransitionToNextScreen
            print("Items")
        }
    }
    
    private var transitionToTask: Binder<Void> {
        return Binder(self) { me, _ in
            // TODO: TransitionToNextScreen
            print("Task")
        }
    }
}
