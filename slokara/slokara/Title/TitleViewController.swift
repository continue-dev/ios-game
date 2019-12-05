import UIKit

class TitleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = CommonFontLabel()
        label.text = "あいう夏スロ異世界！！\n★123１２３";
        label.frame = CGRect(x:10, y:10, width:400, height:200);
        label.setFontSize(size: 32)
        label.numberOfLines = 2
        view.addSubview(label)

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let homeViewController = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as? NavigationChildViewController else { return }
        let navigationController = NavigationViewController.instantiate(rootViewController: homeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        self.present(navigationController, animated: true, completion: nil)
    }
}
