import RxDataSources

struct SectionObItemList {
    var items: [Item]
}

extension SectionObItemList: SectionModelType {
    typealias Item = ItemListModel
    
     init(original: SectionObItemList, items: [Item]) {
      self = original
      self.items = items
    }
}
