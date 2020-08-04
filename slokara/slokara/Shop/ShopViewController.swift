import UIKit
import RxSwift
import RxCocoa

class ShopViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet weak var itemShopButton: BorderedButton!
    @IBOutlet weak var reelShopButton: BorderedButton!
    @IBOutlet weak var adButton: BorderedButton!
    @IBOutlet weak var talkButton: BorderedButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        self.itemShopButton.buttonTapped.bind(to: transitionItemShop).disposed(by: disposeBag)
        self.reelShopButton.buttonTapped.bind(to: transitionReelShop).disposed(by: disposeBag)
        self.adButton.buttonTapped.bind(to: showRewardAd).disposed(by: disposeBag)
        self.talkButton.buttonTapped.bind(to: showConversation).disposed(by: disposeBag)
    }
}

extension ShopViewController {
    private var transitionItemShop: Binder<Void> {
        return Binder(self) { me, _ in
            let navigation = me.parent as! NavigationViewController
            let itemShopVC = UIStoryboard(name: "ItemShop", bundle: nil).instantiateInitialViewController() as! ItemShopViewController
            itemShopVC.title = "アイテム一覧"
            navigation.push(itemShopVC, animate: true)
        }
    }
    
    private var transitionReelShop: Binder<Void> {
        return Binder(self) { me, _ in
            // リールショップ画面へ遷移
        }
    }
    
    private var showRewardAd: Binder<Void> {
        return Binder(self) { me, _ in
            // リワード広告を表示
        }
    }
    
    private var showConversation: Binder<Void> {
        return Binder(self) { me, _ in
            // 会話を表示
        }
    }
}
