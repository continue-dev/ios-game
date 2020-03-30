import Foundation
import RxSwift
import RealmSwift
import RxRealm

protocol NavigationModelProtocol {
    var status: Observable<UserStatus> { get }
}

final class NavigationModelImpl: NavigationModelProtocol {
    private let realm = try! Realm()
    private lazy var userStatus = self.realm.objects(UserStatus.self).first!
    
    var status: Observable<UserStatus> {
        return Observable.from(object: userStatus)
    }
}
