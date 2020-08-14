import RxSwift

final class ItemShopViewModel {
    private let itemShopModel: ItemShopModelProtocol
    private let disposeBag = DisposeBag()
    
    private let itemListSubject = BehaviorSubject<[SectionObItemList]>(value: [])
    var itemList: Observable<[SectionObItemList]> {
        return itemListSubject.asObservable()
    }
    
    private var purchaseList = [Int: Int]() {
        willSet { newValue.filter { $0.value > 0 } }
    }
    

    init(tabSelected: Observable<ItemCategoryTab.TabKind>, selectCell: Observable<ItemListModel>, purchaseNumberChanged: Observable<Int>, itemShopModel: ItemShopModelProtocol = ItemShopModelImpl()) {
        self.itemShopModel = itemShopModel
        
        let oldItemList = BehaviorSubject<[ItemListModel]>(value: [])
        
        let initialItemList = Observable<[ItemListModel]>
            .combineLatest(tabSelected,
                           itemShopModel.itemList,
                           itemShopModel.possessionItemList) { [unowned self] type, items, possessions in
                            let itemList = items.map { ItemListModel(item: $0, possessionNumber: possessions[$0.id] ?? 0, purchaseNumber: self.purchaseList[$0.id] ?? 0)}
                            return itemList
        }
        
        let updateItem = purchaseNumberChanged.withLatestFrom(selectCell) { ($0, $1) }.map { [weak self] (number, item) -> ItemListModel in
            var editedItem = item
            self?.purchaseList[editedItem.item.id] = number
            editedItem.purchaseNumber = number
            return editedItem
        }
        
        let newItemList = updateItem.withLatestFrom(oldItemList) { ($0, $1) }.map { (item, list) -> [ItemListModel] in
            var newList = list
            if let index = list.firstIndex(where: { $0.item.id == item.item.id }) {
                newList[index] = item
            }
            return newList
        }
        
        let itemListStream = Observable.merge(initialItemList, newItemList)
        itemListStream.bind(to: oldItemList).disposed(by: disposeBag)
        
        itemListStream.map { [SectionObItemList(items: $0)] }.bind(to: itemListSubject).disposed(by: disposeBag)
        
    }
    
    private func convertItemType(tab: ItemCategoryTab.TabKind) -> [Item.ItemType] {
        switch tab {
        case .all:
            return [.amulet, .medicine, .equipment]
        case .amulet:
            return [.amulet]
        case .medicine:
            return [.medicine]
        case .equipment:
            return [.equipment]
        }
    }
}
