import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController, NavigationChildViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet weak var buttonFirstView: UIBarButtonItem!
    @IBOutlet weak var buttonSecondView: UIBarButtonItem!
    @IBOutlet weak var buttonThirdView: UIBarButtonItem!
    @IBOutlet weak var buttonFourthView: UIBarButtonItem!
    @IBOutlet weak var buttonFifthView: UIBarButtonItem!
    
    let idList: [String] = ["FirstViewController", "SecondViewController"]

    var pageViewController: UIPageViewController!
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonFirstView.action = #selector(TaskListViewController.barButtonFirstTapped)
        buttonSecondView.action = #selector(TaskListViewController.barButtonSecondTapped)
        buttonThirdView.action = #selector(TaskListViewController.barButtonThirdTapped)
        buttonFourthView.action = #selector(TaskListViewController.barButtonFourthTapped)
        buttonFifthView.action = #selector(TaskListViewController.barButtonFifthTapped)

        for id in idList {
            viewControllers.append((storyboard?.instantiateViewController(withIdentifier: id))!)
        }

        pageViewController = children.first as? UIPageViewController
        pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getFirst() -> FirstViewController {
        return storyboard!.instantiateViewController(withIdentifier:"FirstViewController") as! FirstViewController
    }

    func getSecond() -> SecondViewController {
        return storyboard!.instantiateViewController(withIdentifier:"SecondViewController") as! SecondViewController
    }

    func getThird() -> ThirdViewController {
        return storyboard!.instantiateViewController(withIdentifier:"ThirdViewController") as! ThirdViewController
    }

    func getFourth() -> FourthViewController {
        return storyboard!.instantiateViewController(withIdentifier:"FourthViewController") as! FourthViewController
    }

    func getFifth() -> FifthViewController {
        return storyboard!.instantiateViewController(withIdentifier:"FifthViewController") as! FifthViewController
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: FifthViewController.self) {
            return getFourth()
        } else if viewController.isKind(of: FourthViewController.self) {
            return getThird()
        } else if viewController.isKind(of: ThirdViewController.self) {
            return getSecond()
        } else if viewController.isKind(of: SecondViewController.self) {
            return getFirst()
        } else {
            return nil
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: FirstViewController.self) {
            return getSecond()
        } else if viewController.isKind(of: SecondViewController.self) {
            return getThird()
        } else if  viewController.isKind(of: ThirdViewController.self) {
            return getFourth()
        } else if  viewController.isKind(of: FourthViewController.self) {
            return getFifth()
        } else {
            return nil
        }

    }

    @objc func barButtonFirstTapped(_ sender: UIBarButtonItem) {
        pageViewController.setViewControllers([getFirst()], direction: .forward, animated: true, completion: nil)
    }
    @objc func barButtonSecondTapped(_ sender: UIBarButtonItem) {
        pageViewController.setViewControllers([getSecond()], direction: .forward, animated: true, completion: nil)
    }
    @objc func barButtonThirdTapped(_ sender: UIBarButtonItem) {
        pageViewController.setViewControllers([getThird()], direction: .forward, animated: true, completion: nil)
    }
    @objc func barButtonFourthTapped(_ sender: UIBarButtonItem) {
        pageViewController.setViewControllers([getFourth()], direction: .forward, animated: true, completion: nil)
    }
    @objc func barButtonFifthTapped(_ sender: UIBarButtonItem) {
        pageViewController.setViewControllers([getFifth()], direction: .forward, animated: true, completion: nil)
    }

}
