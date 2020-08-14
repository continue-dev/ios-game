import RxSwift

final class ItemShopViewModel {
    private let itemShopModel: ItemShopModelProtocol
    private let disposeBag = DisposeBag()
    
    private let itemListSubject = BehaviorSubject<[ItemListModel]>(value: [])
    var itemList: Observable<[ItemListModel]> {
        return itemListSubject.asObservable()
    }
    

    init(tabSelected: Observable<ItemCategoryTab.TabKind>, itemShopModel: ItemShopModelProtocol = ItemShopModelImpl()) {
        self.itemShopModel = itemShopModel
        
        Observable.combineLatest(tabSelected, itemShopModel.itemList, itemShopModel.possessionItemList).subscribe(onNext: { [unowned self] type, items, possessions in
            let itemList = items.map { ItemListModel(item: $0, possessionNumber: possessions[$0.id] ?? 0)}
            self.itemListSubject.onNext(itemList.filter { self.convertItemType(tab: type).contains($0.item.itemType) })
            }).disposed(by: disposeBag)
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
