import UIKit
import RxSwift
import RxCocoa

class TaskListTab: UIView {
    
    @IBOutlet weak var tabView: UIStackView!
    
    private var currentGrade: Grade?
    private var currentTab: TabKind?
    private let selectedTabSubject = PublishSubject<TabKind>()
    var tabSelected: Observable<TabKind> { return selectedTabSubject }
        
    private func setCurrentGrade(_ grade: Grade) {
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
        guard let gradeToTab = TabKind(from: currentGrade) else { return }
        
        tabView.subviews.enumerated().forEach { index, view in
            guard let tab = view as? TabButton else { return }
            if index <= TabKind.allCases.firstIndex(of: gradeToTab)! {
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
        currentTab = senderTab
        selectedTabSubject.onNext(senderTab)
    }
    
    enum TabKind: String, CaseIterable {
        case all = "すべて"
        case kindergarten = "幼"
        case primary = "小"
        case juniorHigh = "中"
        case high = "高"
        
        init?(from: Grade) {
            switch from {
            case .wood:
                self = .kindergarten
            case .stone, .copper:
                self = .primary
            case .silver:
                self = .juniorHigh
            case .gold:
                self = .high
            }
        }
        
        var toGrade: [Grade] {
            switch self {
            case .all:
                return [.wood, .stone, .copper, .silver, .gold]
            case .kindergarten:
                return [.wood]
            case .primary:
                return [.stone, .copper]
            case .juniorHigh:
                return [.silver]
            case .high:
                return [.gold]
            }
        }
    }
}

extension TaskListTab {
    func switchNextTab() {
        guard let currentGrade = self.currentGrade else { return }
        guard let currentTab = self.currentTab else { return }
        guard let selectedIndex = TabKind.allCases.firstIndex(of: currentTab) else { return }
        guard selectedIndex < TabKind.allCases.firstIndex(of: TabKind(from: currentGrade)!)! else { return }
        guard let nextTab = tabView.subviews[selectedIndex + 1] as? TabButton else { return }
        tappedTabAction(nextTab)
    }
    
    func switchPrevTab() {
        guard let currentTab = self.currentTab else { return }
        guard let selectedIndex = TabKind.allCases.firstIndex(of: currentTab) else { return }
        guard selectedIndex > 0 else { return }
        guard let prevTab = tabView.subviews[selectedIndex - 1] as? TabButton else { return }
        tappedTabAction(prevTab)
    }
}

extension TaskListTab {
    var bindCurrentGrade: Binder<Grade> {
        return Binder(self) { me, grade in
            me.setCurrentGrade(grade)
        }
    }
}
