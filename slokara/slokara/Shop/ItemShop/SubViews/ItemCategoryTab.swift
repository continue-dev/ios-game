import UIKit
import RxSwift

class ItemCategoryTab: UIView {
    @IBOutlet weak var tabView: UIStackView!
    
    private var currentTab: TabKind?
    private let selectedTabSubject = BehaviorSubject<TabKind>(value: .all)
    var tabSelected: Observable<TabKind> { return selectedTabSubject }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        selectTabToAll()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
        selectTabToAll()
    }
    
    private func loadNib() {
        guard let customView = Bundle.main.loadNibNamed("ItemCategoryTab", owner: self, options: nil)?.first as? UIView else { return }
        customView.frame = self.bounds
        customView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(customView)
    }
    
    private func selectTabToAll() {
        guard let allTab = tabView.subviews.first as? TabButton else { return }
        tappedTabAction(allTab)
    }
    
    private func clearTabState() {
        tabView.subviews.enumerated().forEach { index, view in
            guard let tab = view as? TabButton else { return }
            tab.tabState = .normal
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
        case medicine = "回復"
        case amulet = "お守り"
        case equipment = "装備"
    }
}

extension ItemCategoryTab {
    func switchNextTab() {
        guard let currentTab = self.currentTab else { return }
        guard let selectedIndex = TabKind.allCases.firstIndex(of: currentTab) else { return }
        guard selectedIndex < TabKind.allCases.count else { return }
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
    
    func canGoNext() -> Bool {
        guard let currentTab = self.currentTab else { return false }
        guard let selectedIndex = TabKind.allCases.firstIndex(of: currentTab) else { return false }
        return selectedIndex < TabKind.allCases.count - 1
    }
    
    func canBackPrev() -> Bool {
        guard let currentTab = self.currentTab else { return false }
        guard let selectedIndex = TabKind.allCases.firstIndex(of: currentTab) else { return false }
        return selectedIndex > 0
    }
}

