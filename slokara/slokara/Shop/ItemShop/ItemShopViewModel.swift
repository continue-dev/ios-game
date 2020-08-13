import RxSwift

final class ItemShopViewModel {
    private let itemShopModel: ItemShopModelProtocol
    private let disposeBag = DisposeBag()
    
    private let itemListSubject = BehaviorSubject<[Item]>(value: [])
    var itemList: Observable<[Item]> {
        return itemListSubject.asObservable()
    }
    

    init(tabSelected: Observable<ItemCategoryTab.TabKind>, itemShopModel: ItemShopModelProtocol = ItemShopModelImpl()) {
        self.itemShopModel = itemShopModel
        
        Observable.combineLatest(tabSelected, itemShopModel.itemList).subscribe(onNext: { [unowned self] type, items in
            self.itemListSubject.onNext(items.filter { self.convertItemType(tab: type).contains($0.itemType) })
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
