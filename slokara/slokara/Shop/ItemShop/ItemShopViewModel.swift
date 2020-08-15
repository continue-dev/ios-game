import RxSwift

final class ItemShopViewModel {
    private let itemShopModel: ItemShopModelProtocol
    private let disposeBag = DisposeBag()
    
    private let itemListSubject = BehaviorSubject<[SectionObItemList]>(value: [])
    var itemList: Observable<[SectionObItemList]> {
        return itemListSubject.asObservable()
    }
    
    private var purchaseList = [Int: Int]()
    

    init(tabSelected: Observable<ItemCategoryTab.TabKind>, selectCell: Observable<ItemListModel>, purchaseNumberChanged: Observable<Int>, hidePurchaseControl: Observable<Void>, itemShopModel: ItemShopModelProtocol = ItemShopModelImpl()) {
        self.itemShopModel = itemShopModel
        
        let oldItemList = BehaviorSubject<[ItemListModel]>(value: [])
        
        let initialItemList = Observable<[ItemListModel]>
            .combineLatest(itemShopModel.itemList,
                           itemShopModel.possessionItemList) { [unowned self] items, possessions in
                            let itemList = items.map { ItemListModel(item: $0, possessionNumber: possessions[$0.id] ?? 0, purchaseNumber: self.purchaseList[$0.id] ?? 0)}
                            return itemList
        }
        
        let updateItem = purchaseNumberChanged.withLatestFrom(selectCell) { ($0, $1) }.map { [weak self] (number, item) -> ItemListModel in
            var editedItem = item
            self?.purchaseList[editedItem.item.id] = number
            editedItem.purchaseNumber = number
            editedItem.isSelected = true
            return editedItem
        }
        
        let newItemList = updateItem.withLatestFrom(oldItemList) { ($0, $1) }.map { (item, list) -> [ItemListModel] in
            var newList = list
            
            // 過去に選択されていたセルの選択状態を解除
            if var deSelectItem = list.first(where: { $0.isSelected }),
               let index = list.firstIndex(where: { $0.item.id == deSelectItem.item.id}) {
                deSelectItem.isSelected = false
                newList[index] = deSelectItem
            }
            
            if let index = list.firstIndex(where: { $0.item.id == item.item.id }) {
                newList[index] = item
            }
            return newList
        }
        
        let noSelectionList = hidePurchaseControl.withLatestFrom(oldItemList) { $1 }.map { list -> [ItemListModel] in
            var newList = list

            if var deSelectItem = list.first(where: { $0.isSelected }),
               let index = list.firstIndex(where: { $0.item.id == deSelectItem.item.id}) {
                deSelectItem.isSelected = false
                newList[index] = deSelectItem
            }
            return newList
        }
        
        let itemListStream = Observable.merge(initialItemList, newItemList, noSelectionList)
        itemListStream.bind(to: oldItemList).disposed(by: disposeBag)
        
        let filteredItemListStream = Observable.combineLatest(tabSelected, itemListStream) { ($0, $1) }.map { [unowned self] type, list in
            list.filter { self.convertItemType(tab: type).contains($0.item.itemType) }
        }
        
        filteredItemListStream.map { [SectionObItemList(items: $0)] }.bind(to: itemListSubject).disposed(by: disposeBag)
        
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
