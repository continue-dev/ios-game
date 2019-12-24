import UIKit

class TaskListViewController: UIViewController, NavigationChildViewController {
    @IBOutlet var topSpacer: UIView!
    @IBOutlet private weak var tabView: TaskListTab!
    @IBOutlet private weak var taskListTableView: UITableView!
    
    override func viewDidLoad() {
        tabView.setCurrentGrade(.silver)
        taskListTableView.register(UINib(nibName: "TaskListCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TaskListCell
            else { return UITableViewCell() }
        
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
