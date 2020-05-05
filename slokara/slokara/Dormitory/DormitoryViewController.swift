import UIKit
import RxSwift
import RxCocoa

class DormitoryViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet weak var statusButton: BorderedButton!
    @IBOutlet weak var itemButton: BorderedButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        self.statusButton.buttonTapped.bind(to: transitionToStatus).disposed(by: disposeBag)
        self.itemButton.buttonTapped.bind(to: transitionToItem).disposed(by: disposeBag)
    }
}

extension DormitoryViewController {
    private var transitionToStatus: Binder<Void> {
        return Binder(self) { me, _ in
            let navigation = me.parent as! NavigationViewController
            let parameterVC = UIStoryboard(name: "Parameter", bundle: nil).instantiateInitialViewController() as! NavigationChildViewController
            parameterVC.title = "ステータス"
            navigation.push(parameterVC, animate: true)
        }
    }
    
    private var transitionToItem: Binder<Void> {
        return Binder(self) { me, _ in
            // アイテム画面へ遷移
        }
    }
}
