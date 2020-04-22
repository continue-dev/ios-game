import UIKit
import RxSwift
import RxCocoa

class ReelView: UIView {
    
    @IBOutlet private weak var frameImageView: UIImageView!
    @IBOutlet private weak var leftTopStone: UIView!
    @IBOutlet private weak var leftCenterStone: UIView!
    @IBOutlet private weak var leftBottomStone: UIView!
    @IBOutlet private weak var rightTopStone: UIView!
    @IBOutlet private weak var rightCenterStone: UIView!
    @IBOutlet private weak var rightBottomStone: UIView!
    @IBOutlet private weak var topBackStackView: UIStackView!
    @IBOutlet private weak var centerBackStackView: UIStackView!
    @IBOutlet private weak var bottomBackStackView: UIStackView!
    
    private let disposeBag = DisposeBag()
    private var reelChars = [ReelCharacter?]()
    private(set) var isAnimating = false
    
    private var results = [AttributeType?]()
    private let reelStopEvent = PublishRelay<[AttributeType?]>()
    var reelStopped: Observable<[AttributeType?]> { return reelStopEvent.asObservable() }
    
    var reel: Reel? {
        didSet { line = reel?.lines }
    }
    
    private var line: ReelLine? {
        didSet { setUpFrame() }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        guard let view = Bundle.main.loadNibNamed("ReelView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        addSubview(view)
    }
    
    private func setUpFrame() {
        self.frameImageView.image = line?.frameImage
        addConstraints()
        applyBackGrounds()
        addReelCharacters()
        bind()
    }
    
    private func bind() {
        Observable.zip(self.reelChars.compactMap{ $0?.animationStoped }).subscribe(onNext: { [unowned self] _ in
            guard self.isAnimating else { return }
            self.reelStopEvent.accept(self.results)
            self.isAnimating.toggle()
        }).disposed(by: disposeBag)
    }
    
    func startAnimation() {
        guard !self.isAnimating else { return }
        self.results.removeAll()
        self.reelChars.compactMap{ $0 }.enumerated().forEach { offset, element in
            element.startAnimation(delay: Double(offset)/20)
        }
        self.isAnimating.toggle()
    }
    
    func stopAnimation(results: [AttributeType?]) {
        guard self.isAnimating else { return }
        self.results = results
        self.reelChars.compactMap{ $0 }.enumerated().forEach { offset, element in
            element.stopAnimation(result: results.compactMap{$0}[offset], delay: Double(offset)/20)
        }
    }
    
    private func addConstraints() {
        switch self.line {
        case .single:
            self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 334/1160).isActive = true
            self.leftCenterStone.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/5).isActive = true
            self.rightCenterStone.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/5).isActive = true
        case .double:
            self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 615/1160).isActive = true
            self.leftCenterStone.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/9).isActive = true
            self.rightCenterStone.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/9).isActive = true
        case .triple:
            self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 898/1160).isActive = true
            self.leftCenterStone.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/13).isActive = true
            self.rightCenterStone.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/13).isActive = true
        case .none:
            break
        }
    }
    
    private func applyBackGrounds() {
        self.topBackStackView.isHidden = self.line != .triple
        self.centerBackStackView.isHidden = self.line == .single
        guard let reels = self.reel?.enableLines else { return }
        reels.last?.enumerated().forEach { [weak self] offset, element in
            self?.bottomBackStackView.subviews[offset].backgroundColor = element ? UIColor.white : UIColor.darkGray
        }
        
        if reels.count > 1 {
            reels[reels.count-2].enumerated().forEach { [weak self] offset, element in
                self?.centerBackStackView.subviews[offset].backgroundColor = element ? UIColor.white : UIColor.darkGray
            }
        }
        
        if reels.count > 2 {
            reels.first?.enumerated().forEach { [weak self] offset, element in
                self?.topBackStackView.subviews[offset].backgroundColor = element ? UIColor.white : UIColor.darkGray
            }
        }
    }
    
    private func addReelCharacters() {
        guard let reels = self.reel?.enableLines else { return }
        
        if reels.count > 2 {
            reels.first?.enumerated().forEach { [weak self] offset, element in
                guard element else { self?.reelChars.append(nil); return }
                let char = ReelCharacter(frame: .zero)
                char.translatesAutoresizingMaskIntoConstraints = false
                guard let view = self?.topBackStackView.subviews[offset] else { return }
                view.addSubview(char)
                self?.reelChars.append(char)
                
                char.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                char.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                char.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
                char.heightAnchor.constraint(equalTo: char.widthAnchor).isActive = true
            }
        }
        
        if reels.count > 1 {
            reels[reels.count-2].enumerated().forEach { [weak self] offset, element in
                guard element else { self?.reelChars.append(nil); return }
                let char = ReelCharacter(frame: .zero)
                char.translatesAutoresizingMaskIntoConstraints = false
                guard let view = self?.centerBackStackView.subviews[offset] else { return }
                view.addSubview(char)
                self?.reelChars.append(char)
                
                char.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                char.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                char.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
                char.heightAnchor.constraint(equalTo: char.widthAnchor).isActive = true
            }
        }
        
        reels.last?.enumerated().forEach { [weak self] offset, element in
            guard element else { return }
            let char = ReelCharacter(frame: .zero)
            char.translatesAutoresizingMaskIntoConstraints = false
            guard let view = self?.bottomBackStackView.subviews[offset] else { return }
            view.addSubview(char)
            self?.reelChars.append(char)
            
            char.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            char.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            char.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
            char.heightAnchor.constraint(equalTo: char.widthAnchor).isActive = true
        }
    }
}
