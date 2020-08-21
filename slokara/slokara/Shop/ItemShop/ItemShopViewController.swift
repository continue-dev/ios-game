import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ItemShopViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet private weak var currentCoinsLabel: CommonFontLabel!
    @IBOutlet private weak var futureCoinsLabel: CommonFontLabel!
    @IBOutlet private weak var itemListTableView: UITableView!
    @IBOutlet private weak var categoryTabView: ItemCategoryTab!
    @IBOutlet private weak var purchaseControlView: PurchaseControlView!
    @IBOutlet private weak var cartButton: CartButton!
    
    @IBOutlet private weak var puchaseControlBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var purchaseControlTopConstraint: NSLayoutConstraint!
    private var isAnimating = false
    
    private let disposeBag = DisposeBag()
    private let tableDragEvent = PublishRelay<Void>()
    private lazy var viewModel = ItemShopViewModel(tabSelected: categoryTabView.tabSelected, selectCell: itemListTableView.rx.modelSelected(ItemListModel.self).asObservable(), hidePurchaseControl: hidePurchaseControlViewEvent, purchasePlusTapped: purchaseControlView.plusButtonTapped, purchaseMinusTapped: purchaseControlView.minusButtonTapped, purchaseButtonTapped: cartButton.purchaseEvent)
    private lazy var hidePurchaseControlViewEvent = Observable.merge(purchaseControlView.hideViewEvent, tableDragEvent.asObservable(), categoryTabView.tabSelected.map{ _ in () }).filter { [unowned self] in !self.purchaseControlView.isHidden && !self.isAnimating  }.throttle(.seconds(1), latest: false, scheduler: MainScheduler())
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionObItemList>(
      configureCell: { dataSource, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ItemShopListCell else { return UITableViewCell() }
        cell.setItem(item: item.item)
        cell.setPossession(number: item.possessionNumber)
        cell.setPurchase(number: item.purchaseNumber)
        cell.didSelected = item.isSelected
        return cell
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        itemListTableView.register(UINib(nibName: "ItemShopListCell", bundle: nil), forCellReuseIdentifier: "Cell")
        bind()
    }
    
    private func bind() {
        viewModel.itemList.bind(to: itemListTableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        viewModel.currentCoins.map { "\($0)" }.bind(to: currentCoinsLabel.rx.text).disposed(by: disposeBag)
        viewModel.costCoins.map { "\($0)" }.bind(to: futureCoinsLabel.rx.text).disposed(by: disposeBag)
        viewModel.purchaseNumber.bind(to: setPurchaseNumber).disposed(by: disposeBag)
        viewModel.completePurchase.bind(to: dismiss).disposed(by: disposeBag)
        itemListTableView.rx.setDelegate(self).disposed(by: disposeBag)
        itemListTableView.rx.modelSelected(ItemListModel.self).bind(to: showPurchaseControlView).disposed(by: disposeBag)
        itemListTableView.rx.itemSelected.bind(to: fixTableViewOffset).disposed(by: disposeBag)
        hidePurchaseControlViewEvent.bind(to: hidePurchaseControlView).disposed(by: disposeBag)
        tableDragEvent.bind(to: deselectCartButton).disposed(by: disposeBag)
        itemListTableView.rx.didScroll.subscribe({ [unowned self] _ in
            guard let indicator = self.itemListTableView.subviews.last else { return }
            indicator.backgroundColor = UIColor(red: 47.0 / 255, green: 214.0 / 255, blue: 130.0 / 255, alpha: 1)
            }).disposed(by: disposeBag)
    }
}

extension ItemShopViewController {
    private var showPurchaseControlView: Binder<ItemListModel> {
        return Binder(self) { me, item in
            me.isAnimating = true
            me.purchaseControlView.isHidden = false
            me.purchaseControlView.setItemListModel(model: item)
            UIView.animate(withDuration: 0.2, animations: {
                me.purchaseControlTopConstraint.isActive = false
                me.puchaseControlBottomConstraint.isActive = true
                me.view.layoutIfNeeded()
            }) { _ in
                me.isAnimating = false
            }
        }
    }
    
    private var hidePurchaseControlView: Binder<Void> {
        return Binder(self) { me, _ in
            guard !me.purchaseControlView.isHidden && !me.isAnimating else { return }
            me.isAnimating = true
            UIView.animate(withDuration: 0.2, animations: {
                me.purchaseControlTopConstraint.isActive = true
                me.puchaseControlBottomConstraint.isActive = false
                me.view.layoutIfNeeded()
            }) { _ in
                me.purchaseControlView.isHidden = true
                me.isAnimating = false
            }
        }
    }
    
    private var fixTableViewOffset: Binder<IndexPath> {
        return Binder(self) { me, index in
            let cellRect = me.itemListTableView.rectForRow(at: index)
            let rectInView = me.itemListTableView.convert(cellRect, to: me.view)
            if rectInView.maxY >= me.itemListTableView.frame.maxY {
                me.itemListTableView.scrollToRow(at: index, at: .bottom, animated: true)
            }
        }
    }
    
    private var setPurchaseNumber: Binder<Int> {
        return Binder(self) { me, number in
            me.purchaseControlView.setPurchaseNumber(number)
        }
    }
    
    private var deselectCartButton: Binder<Void> {
        return Binder(self) { me, _ in
            me.cartButton.deSelect()
        }
    }
    
    private var dismiss: Binder<Void> {
        return Binder(self) { me, _ in
            let navigation = me.parent as! NavigationViewController
            navigation.popViewController(animate: true)
        }
    }
}

extension ItemShopViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableDragEvent.accept(())
    }
}
