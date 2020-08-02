import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController, NavigationChildViewController {
    
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet private weak var kochoButton: UIButton!
    @IBOutlet private weak var kodoButton: UIButton!
    @IBOutlet private weak var ryoButton: UIButton!
    @IBOutlet private weak var shopButton: UIButton!
    @IBOutlet private weak var lockerButton: UIButton!
    @IBOutlet private weak var roomButton: UIButton!
    @IBOutlet private weak var tuningView: UIView!
    @IBOutlet private weak var tuningSwitch: UISwitch!
    
    private lazy var viewModel = HomeViewModel(
        kochoButtonTapped: kochoButton.rx.tap.asObservable(),
        kodoButtonTapped: kodoButton.rx.tap.asObservable(),
        ryoButtonTapped: ryoButton.rx.tap.asObservable(),
        shopButtonTapped: shopButton.rx.tap.asObservable(),
        lockerButtonTapped: lockerButton.rx.tap.asObservable(),
        roomButtonTapped: roomButton.rx.tap.asObservable())
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.transitionToFinalButtle
            .bind(to: transitionToFinalButtle)
            .disposed(by: disposeBag)
        
        viewModel.transitionToBossButtle
            .bind(to: transitionToBossButtle)
            .disposed(by: disposeBag)
        
        viewModel.transitionToShop
            .bind(to: transitionToShop)
            .disposed(by: disposeBag)
        
        viewModel.transitionToItems
            .bind(to: transitionToItems)
            .disposed(by: disposeBag)
        
        viewModel.transitionToStatus
            .bind(to: transitionToStatus)
            .disposed(by: disposeBag)
        
        viewModel.transitionToTask
            .bind(to: transitionToTask)
            .disposed(by: disposeBag)
        
        #if !PROD
        tuningSwitch.isOn = UserDefaults.standard.bool(forKey: "tuningMode")
        tuningView.isHidden = false
        #endif
    }
    
    @IBAction func tuningSwitchAction(_ sender: UISwitch) {
        let ud = UserDefaults.standard
        ud.set(sender.isOn, forKey: "tuningMode")
        let navigation = self.parent as! NavigationViewController
        navigation.changeTuningMode(isOn: sender.isOn)
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
            
            // 仮の画面遷移（前の画面に戻る）
            let navigation = me.parent as! NavigationViewController
            navigation.popViewController(animate: true)
        }
    }
    
    private var transitionToStatus: Binder<Void> {
        return Binder(self) { me, _ in
            let navigation = me.parent as! NavigationViewController
            let dormitoryVC = UIStoryboard(name: "Dormitory", bundle: nil).instantiateInitialViewController() as! NavigationChildViewController
            dormitoryVC.title = "学生寮"
            navigation.push(dormitoryVC, animate: true)
        }
    }
    
    private var transitionToShop: Binder<Void> {
        return Binder(self) { me, _ in
            #if !PROD
            if UserDefaults.standard.bool(forKey: "tuningMode") {
                let navigation = me.parent as! NavigationViewController
                let tuningReelVC = UIStoryboard(name: "TuningReel", bundle: nil).instantiateInitialViewController() as! TuningReelViewController
                navigation.push(tuningReelVC, animate: true)
                return
            }
            #endif
            
            let navigation = me.parent as! NavigationViewController
            let shopVC = UIStoryboard(name: "Shop", bundle: nil).instantiateInitialViewController() as! ShopViewController
            shopVC.title = "購買部"
            navigation.push(shopVC, animate: true)
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
            let navigation = me.parent as! NavigationViewController
            let taskListVC = UIStoryboard(name: "TaskList", bundle: nil).instantiateInitialViewController() as! NavigationChildViewController
            taskListVC.title = "課題リスト"
            navigation.push(taskListVC, animate: true)
        }
    }
}
