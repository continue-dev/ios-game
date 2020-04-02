import UIKit

class ClearedViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet private weak var taskCellView: TaskCellView!
    @IBOutlet weak var stampView: UIImageView!
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = false
        (self.parent as? NavigationViewController)?.backButtonIsHidden(true)
        if let task = self.task {
            self.taskCellView.setTask(task)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animToAlfaMax()
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
        }) { (_) in
            
        }
    }
}
