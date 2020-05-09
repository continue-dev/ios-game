import Foundation
import RxSwift
import RealmSwift
import RxRealm

protocol NavigationModelProtocol {
    var status: Observable<([UserStatus], RealmChangeset?)> { get }
}

final class NavigationModelImpl: NavigationModelProtocol {
    private let realm = try! Realm()
    private lazy var userStatus = self.realm.objects(UserStatus.self)
    
    var status: Observable<([UserStatus], RealmChangeset?)> {
        return Observable.arrayWithChangeset(from: userStatus)
    }
}
