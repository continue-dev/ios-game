import UIKit
import RxSwift

class ReelShoppingView: UIView {
    @IBOutlet private weak var firstStackView: UIStackView!
    @IBOutlet private weak var secondStackView: UIStackView!
    @IBOutlet private weak var thirdStackView: UIStackView!
    
    private var reelStatus: [[ReelStatusView.ShopReelStatus]]!
    private let disposeBag = DisposeBag()
    
    private let reelStatusRelay = PublishSubject<[[ReelStatusView.ShopReelStatus]]>()
    var reelStateObservable: Observable<[[ReelStatusView.ShopReelStatus]]> {
        reelStatusRelay.asObservable()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setReelStatus(reel: Reel) {
        self.reelStatus = trancerateStatus(reel: reel)
        applyReel()
    }
    
    private func setUp() {
        guard let view = Bundle.main.loadNibNamed("ReelShoppingView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }
    
    private func applyReel() {
        guard let topLeft = firstStackView.arrangedSubviews[0] as? ReelStatusView,
              let topMiddle = firstStackView.arrangedSubviews[1] as? ReelStatusView,
              let topRight = firstStackView.arrangedSubviews[2] as? ReelStatusView,
              let centerLeft = secondStackView.arrangedSubviews[0] as? ReelStatusView,
              let centerMiddle = secondStackView.arrangedSubviews[1] as? ReelStatusView,
              let centerRight = secondStackView.arrangedSubviews[2] as? ReelStatusView,
              let bottomLeft = thirdStackView.arrangedSubviews[0] as? ReelStatusView,
              let bottomMiddle = thirdStackView.arrangedSubviews[1] as? ReelStatusView,
              let bottomRight = thirdStackView.arrangedSubviews[2] as? ReelStatusView else { return }
        
        topLeft.setState(type: self.reelStatus[0][0])
        topMiddle.setState(type: self.reelStatus[0][1])
        topRight.setState(type: self.reelStatus[0][2])
        centerLeft.setState(type: self.reelStatus[1][0])
        centerMiddle.setState(type: self.reelStatus[1][1])
        centerRight.setState(type: self.reelStatus[1][2])
        bottomLeft.setState(type: self.reelStatus[2][0])
        bottomMiddle.setState(type: self.reelStatus[2][1])
        bottomRight.setState(type: self.reelStatus[2][2])
        
        Observable.merge([
            topLeft.taped, topMiddle.taped, topRight.taped,
            centerLeft.taped, centerMiddle.taped, centerRight.taped,
            bottomLeft.taped, bottomMiddle.taped, bottomRight.taped
        ]).subscribe(onNext: { [weak self] (_) in
            let newReel = [
                [topLeft.getState(), topMiddle.getState(), topRight.getState()],
                [centerLeft.getState(), centerMiddle.getState(), centerRight.getState()],
                [bottomLeft.getState(), bottomMiddle.getState(), bottomRight.getState()]
            ]
            self?.reelStatusRelay.onNext(newReel)
        }).disposed(by: disposeBag)

    }
    
    private func trancerateStatus(reel: Reel) -> [[ReelStatusView.ShopReelStatus]] {
        let top: [ReelStatusView.ShopReelStatus] = [
            reel.top[0] ? .hold(checkContactArea(top: false, right: reel.top[1], bottom: reel.center[0], left: false, topLeft: false, topRight: false, bottomLeft: false, bottomRight: reel.center[1])) : checkOnSale(aroundReel: [reel.top[1], reel.center[0], reel.center[1]]),
            reel.top[1] ? .hold(checkContactArea(top: false, right: reel.top[2], bottom: reel.center[1], left: reel.top[0], topLeft: false, topRight: false, bottomLeft: reel.center[0], bottomRight: reel.center[2])) : checkOnSale(aroundReel: [reel.top[0], reel.top[2], reel.center[1]]),
            reel.top[2] ? .hold(checkContactArea(top: false, right: false, bottom: reel.center[2], left: reel.top[1], topLeft: false, topRight: false, bottomLeft: reel.center[1], bottomRight: false)) : checkOnSale(aroundReel: [reel.top[1], reel.center[2], reel.center[1]])
        ]
        let center: [ReelStatusView.ShopReelStatus] = [
            reel.center[0] ? .hold(checkContactArea(top: reel.top[0], right: reel.center[1], bottom: reel.bottom[0], left: false, topLeft: false, topRight: reel.top[1], bottomLeft: false, bottomRight: reel.bottom[1])) : checkOnSale(aroundReel: [reel.top[0], reel.center[1], reel.bottom[0]]),
            reel.center[1] ? .hold(checkContactArea(top: reel.top[1], right: reel.center[2], bottom: reel.bottom[1], left: reel.center[0], topLeft: reel.top[0], topRight: reel.top[2], bottomLeft: reel.bottom[0], bottomRight: reel.bottom[2])) : checkOnSale(aroundReel: [reel.top[0], reel.top[1], reel.top[2], reel.center[0], reel.center[2], reel.bottom[0], reel.bottom[1], reel.bottom[2]]),
            reel.center[2] ? .hold(checkContactArea(top: reel.top[2], right: false, bottom: reel.bottom[2], left: reel.center[1], topLeft: reel.top[1], topRight: false, bottomLeft: reel.bottom[1], bottomRight: false)) : checkOnSale(aroundReel: [reel.top[2], reel.center[1], reel.bottom[2]]),
        ]
        let bottom: [ReelStatusView.ShopReelStatus] = [
            reel.bottom[0] ? .hold(checkContactArea(top: reel.center[0], right: reel.bottom[1], bottom: false, left: false, topLeft: false, topRight: reel.center[1], bottomLeft: false, bottomRight: false)) : checkOnSale(aroundReel: [reel.center[0], reel.center[1], reel.bottom[1]]),
            reel.bottom[1] ? .hold(checkContactArea(top: reel.center[1], right: reel.bottom[2], bottom: false, left: reel.bottom[0], topLeft: reel.center[0], topRight: reel.center[2], bottomLeft: false, bottomRight: false)) : checkOnSale(aroundReel: [reel.center[1], reel.bottom[0], reel.bottom[2]]),
            reel.bottom[2] ? .hold(checkContactArea(top: reel.center[2], right: false, bottom: false, left: reel.bottom[1], topLeft: reel.center[1], topRight: false, bottomLeft: false, bottomRight: false)) : checkOnSale(aroundReel: [reel.center[1], reel.center[2], reel.bottom[1]]),
        ]
        
        return [top, center, bottom]
    }
    
    private func checkContactArea(top: Bool, right: Bool, bottom: Bool, left: Bool, topLeft: Bool, topRight: Bool, bottomLeft: Bool, bottomRight: Bool) -> [ReelStatusView.ShopReelStatus.ContactArea] {
        var areas = [ReelStatusView.ShopReelStatus.ContactArea]()
        if top {
            areas.append(.top)
        }
        if right {
            areas.append(.right)
        }
        if bottom {
            areas.append(.bottom)
        }
        if left {
            areas.append(.left)
        }
        if topLeft {
            areas.append(.topLeft)
        }
        if topRight {
            areas.append(.topRight)
        }
        if bottomLeft {
            areas.append(.bottomLeft)
        }
        if bottomRight {
            areas.append(.bottomRight)
        }
        return areas
    }
    
    private func checkOnSale(aroundReel: [Bool]) -> ReelStatusView.ShopReelStatus {
        return aroundReel.contains(true) ? .onSale : .disable
    }
}
