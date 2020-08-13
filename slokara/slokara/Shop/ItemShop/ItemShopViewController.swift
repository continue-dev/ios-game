import UIKit
import RxSwift
import RxCocoa

class ItemShopViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet private weak var itemListTableView: UITableView!
    @IBOutlet private weak var categoryTabView: ItemCategoryTab!
    
    private let disposeBag = DisposeBag()
    private lazy var viewModel = ItemShopViewModel(tabSelected: categoryTabView.tabSelected)

    override func viewDidLoad() {
        super.viewDidLoad()
        itemListTableView.register(UINib(nibName: "ItemShopListCell", bundle: nil), forCellReuseIdentifier: "Cell")
        bind()
    }
    
    private func bind() {
        viewModel.itemList.bind(to: itemListTableView.rx.items(cellIdentifier: "Cell", cellType: ItemShopListCell.self)) {index, item, cell in
            cell.setItem(item: item)
        }.disposed(by: disposeBag)
    }
}
