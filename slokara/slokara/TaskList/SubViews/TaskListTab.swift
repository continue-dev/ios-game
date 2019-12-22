import UIKit
import RxSwift

class TaskListTab: UIView {
    
    @IBOutlet weak var tabView: UIStackView!
    
    private var currentGrade: Grade?
    private let selectedTabSubject = PublishSubject<TabKind>()
    var tabSelected: Observable<TabKind> { return selectedTabSubject }
        
    func setCurrentGrade(_ grade: Grade) {
        currentGrade = grade
        clearTabState()
        guard let allTab = tabView.subviews.first as? TabButton else { return }
        tappedTabAction(allTab)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
    
    private func loadNib() {
        guard let customView = Bundle.main.loadNibNamed("TaskListTab", owner: self, options: nil)?.first as? UIView else { return }
        customView.frame = self.bounds
        self.addSubview(customView)
    }
    
    private func clearTabState() {
        guard let currentGrade = self.currentGrade else { return }
        var current: TabKind {
            switch currentGrade {
            case .wood:
                return .kindergarten
            case .stone, .copper:
                return .primary
            case .silver:
                return .juniorHigh
            case .gold:
                return .high
            }
        }
        
        for view in tabView.subviews.enumerated() {
            guard let tab = view.element as? TabButton else { continue }
            if view.offset <= TabKind.allCases.firstIndex(of: current)! {
                tab.tabState = .normal
            } else {
                tab.tabState = .disable
            }
        }
    }
    
    @IBAction private func tappedTabAction(_ sender: TabButton) {
        clearTabState()
        sender.tabState = .selected
        guard let tabTitle = sender.titleLabel?.text, let senderTab = TabKind(rawValue: tabTitle) else { return }
        selectedTabSubject.onNext(senderTab)
    }
    
    enum TabKind: String, CaseIterable {
        case all = "すべて"
        case kindergarten = "幼"
        case primary = "小"
        case juniorHigh = "中"
        case high = "高"
    }
}
