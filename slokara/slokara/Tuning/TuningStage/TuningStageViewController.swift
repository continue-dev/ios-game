import UIKit

class TuningStageViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var enterButton: UIButton!
    
    var task: Task!
    
    private var enemies = [Enemy]() {
        didSet { self.enterButton.isEnabled = enemies.count > 0 }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "TuningStageTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.tableFooterView = UIView()
    }
    
    @IBAction func enterAction(_ sender: Any) {
        guard let battleViewController = UIStoryboard(name: "Battle", bundle: nil).instantiateInitialViewController() as? BattleViewController else { return }
        
        let stage = Stage(id: 0, backGroundName: "background_sample", enemies: self.enemies)
        UserDefaults.standard.set(stage.toJson(), forKey: "editedStage")

        battleViewController.task = self.task
        let navigationController = self.parent as! NavigationViewController
        navigationController.push(battleViewController, animate: true)
    }
    
}

extension TuningStageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section > 0 ? 1 : self.enemies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TuningStageTableViewCell else { return UITableViewCell() }
            cell.setEnemy(enemy: self.enemies[indexPath.row])
            return cell
        default:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.textLabel?.text = "敵を追加"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
}

extension TuningStageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return true
        default:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.enemies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
