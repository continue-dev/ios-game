import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ItemShopViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet private weak var itemListTableView: UITableView!
    @IBOutlet private weak var categoryTabView: ItemCategoryTab!
    @IBOutlet private weak var purchaseControlView: PurchaseControlView!
    
    private let disposeBag = DisposeBag()
    private lazy var viewModel = ItemShopViewModel(tabSelected: categoryTabView.tabSelected, selectCell: itemListTableView.rx.modelSelected(ItemListModel.self).asObservable(), purchaseNumberChanged: purchaseControlView.purchaseNumber)
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionObItemList>(
      configureCell: { dataSource, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ItemShopListCell else { return UITableViewCell() }
        cell.setItem(item: item.item)
        cell.setPossession(number: item.possessionNumber)
        cell.setPurchase(number: item.purchaseNumber)
        return cell
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        itemListTableView.register(UINib(nibName: "ItemShopListCell", bundle: nil), forCellReuseIdentifier: "Cell")
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.purchaseControlView.translatesAutoresizingMaskIntoConstraints = true
        self.purchaseControlView.transform = CGAffineTransform(translationX: 0, y: self.purchaseControlView.bounds.height)
    }
    
    private func bind() {
        viewModel.itemList.bind(to: itemListTableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        itemListTableView.rx.modelSelected(ItemListModel.self).bind(to: showPurchaseControlView).disposed(by: disposeBag)
    }
}

extension ItemShopViewController {
    private var showPurchaseControlView: Binder<ItemListModel> {
        return Binder(self) { me, item in
            me.purchaseControlView.isHidden = false
            me.purchaseControlView.setItemListModel(model: item)
            UIView.animate(withDuration: 0.2) {
                me.purchaseControlView.transform = .identity
            }
        }
    }
}
