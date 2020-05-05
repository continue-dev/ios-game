import UIKit

class TuningStageViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var enterButton: UIButton!
    
    var task: Task!
    
    var enemies = [Enemy]() {
        didSet {
            self.enterButton.isEnabled = enemies.count > 0
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "TuningStageTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.tableFooterView = UIView()
        self.tableView.dragDelegate = self
        self.tableView.dropDelegate = self
        self.tableView.dragInteractionEnabled = true
        loadStage()
    }
    
    private func loadStage() {
        guard let json = UserDefaults.standard.data(forKey: "editedStage") else { return }
        guard let stage =  try? JSONDecoder().decode(Stage.self, from: json) else { fatalError("Stage decode failed.") }
        enemies = stage.enemies
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
        guard let createViewController = UIStoryboard(name: "CreateEnemy", bundle: nil).instantiateInitialViewController() as? CreateEnemyViewController else { return }
        if indexPath.section == 0 {
            createViewController.editingEnemy = (indexPath.row, self.enemies[indexPath.row])
        }
        DispatchQueue.main.async {
            self.present(createViewController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 174 : 45
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

extension TuningStageViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension TuningStageViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let item = coordinator.items.first,
            let destinationIndexPath = coordinator.destinationIndexPath,
            let sourceIndexPath = item.sourceIndexPath else { return }

        tableView.performBatchUpdates({ [unowned self] in
            let moveItem = self.enemies.remove(at: sourceIndexPath.row)
            self.enemies.insert(moveItem, at: destinationIndexPath.row)
            tableView.deleteRows(at: [sourceIndexPath], with: .automatic)
            tableView.insertRows(at: [destinationIndexPath], with: .automatic)
            }, completion: nil)
        coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
    }
}
