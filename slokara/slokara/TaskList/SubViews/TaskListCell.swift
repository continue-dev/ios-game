import UIKit

class TaskListCell: UITableViewCell {
    
    @IBOutlet weak var taskCellView: TaskCellView!
    
    func setTask(_ task: Task) {
        taskCellView.setTask(task)
    }
}
