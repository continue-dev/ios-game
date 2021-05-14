import UIKit
import RealmSwift

class TitleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = CommonFontLabel()
        
        #if DEV
        label.text = "This is development version.";
        #elseif ADHOC
        label.text = "This is adhoc version.";
        #else
        label.text = "あいう夏スロ異世界！！\n★123１２３";
        #endif
        
        label.frame = CGRect(x:10, y:10, width:400, height:200);
        label.setFontSize(size: 32)
        label.numberOfLines = 2
        view.addSubview(label)
        
        fetchSaveData()
    }
    
    private func fetchSaveData() {
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        if realm.objects(UserStatus.self).isEmpty {
            try! realm.write {
                realm.add(UserStatus())
            }
        }
        if realm.objects(ReelStatus.self).isEmpty {
            try! realm.write {
                realm.add(ReelStatus())
            }
        }
        
        #if !PROD
        if realm.objects(UserStatus.self).count < 2 {
            let user = UserStatus()
            user.numberOfCoins = 9999999
            user.numberOfCredit = 9999
            try! realm.write {
                realm.add(user)
            }
        }
        if realm.objects(ReelStatus.self).count < 2 {
            try! realm.write {
                realm.add(ReelStatus())
            }
        }
        #endif
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let homeViewController = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as? NavigationChildViewController else { return }
        let navigationController = NavigationViewController.instantiate(rootViewController: homeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        self.present(navigationController, animated: true, completion: nil)
    }
}
