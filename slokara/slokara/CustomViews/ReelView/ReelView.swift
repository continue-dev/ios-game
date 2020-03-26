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
    
    private let disposeBag = DisposeBag()
    private var reelChars = [ReelCharacter]()
    private(set) var isAnimating = false
    
    private var results = [AttributeType]()
    private let reelStopEvent = PublishRelay<[AttributeType]>()
    var reelStopped: Observable<[AttributeType]> { return reelStopEvent.asObservable() }
    
    var line: ReelLine? {
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
        addReelCharacters()
        bind()
    }
    
    private func bind() {
        Observable.zip(self.reelChars.map{ $0.animationStoped }).subscribe(onNext: { [unowned self] _ in
            guard self.isAnimating else { return }
            self.reelStopEvent.accept(self.results)
            self.isAnimating.toggle()
        }).disposed(by: disposeBag)
    }
    
    func startAnimation() {
        guard !self.isAnimating else { return }
        self.results.removeAll()
        self.reelChars.enumerated().forEach { offset, element in
            element.startAnimation(delay: Double(offset)/20)
        }
        self.isAnimating.toggle()
    }
    
    func stopAnimation(results: [AttributeType]) {
        guard self.isAnimating else { return }
        guard results.count == self.line?.numberOfCharacter else { assert(false, "Reel lines dosen't match."); return }
        self.results = results
        self.reelChars.enumerated().forEach { offset, element in
            element.stopAnimation(result: results[offset], delay: Double(offset)/20)
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
    
    private func addReelCharacters() {
        let bottomReelCenter = ReelCharacter(frame: .zero)
        bottomReelCenter.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomReelCenter)
        let bottomReelLeft = ReelCharacter(frame: .zero)
        bottomReelLeft.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomReelLeft)
        let bottomReelRight = ReelCharacter(frame: .zero)
        bottomReelRight.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomReelRight)
        self.reelChars.append(bottomReelLeft)
        self.reelChars.append(bottomReelCenter)
        self.reelChars.append(bottomReelRight)
        
        let screenSize = UIScreen.main.bounds
        bottomReelCenter.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bottomReelCenter.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/6).isActive = true
        bottomReelCenter.heightAnchor.constraint(equalTo: bottomReelCenter.widthAnchor).isActive = true
        bottomReelCenter.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -screenSize.width/13).isActive = true
        bottomReelLeft.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/6).isActive = true
        bottomReelLeft.heightAnchor.constraint(equalTo: bottomReelLeft.widthAnchor).isActive = true
        bottomReelLeft.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -screenSize.width/13).isActive = true
        bottomReelLeft.trailingAnchor.constraint(equalTo: bottomReelCenter.leadingAnchor, constant: -screenSize.width/11).isActive = true
        bottomReelRight.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/6).isActive = true
        bottomReelRight.heightAnchor.constraint(equalTo: bottomReelRight.widthAnchor).isActive = true
        bottomReelRight.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -screenSize.width/13).isActive = true
        bottomReelRight.leadingAnchor.constraint(equalTo: bottomReelCenter.trailingAnchor, constant: screenSize.width/11).isActive = true
        
        if self.line != ReelLine.single {
            let middleReelCenter = ReelCharacter(frame: .zero)
            middleReelCenter.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(middleReelCenter)
            let middleReelLeft = ReelCharacter(frame: .zero)
            middleReelLeft.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(middleReelLeft)
            let middleReelRight = ReelCharacter(frame: .zero)
            middleReelRight.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(middleReelRight)
            self.reelChars.insert(middleReelRight, at: 0)
            self.reelChars.insert(middleReelCenter, at: 0)
            self.reelChars.insert(middleReelLeft, at: 0)

            
            middleReelCenter.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            middleReelCenter.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/6).isActive = true
            middleReelCenter.heightAnchor.constraint(equalTo: middleReelCenter.widthAnchor).isActive = true
            middleReelCenter.bottomAnchor.constraint(equalTo: bottomReelCenter.topAnchor, constant: -screenSize.width/12).isActive = true
            middleReelLeft.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/6).isActive = true
            middleReelLeft.heightAnchor.constraint(equalTo: middleReelLeft.widthAnchor).isActive = true
            middleReelLeft.bottomAnchor.constraint(equalTo: bottomReelLeft.topAnchor, constant: -screenSize.width/12).isActive = true
            middleReelLeft.trailingAnchor.constraint(equalTo: middleReelCenter.leadingAnchor, constant: -screenSize.width/11).isActive = true
            middleReelRight.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/6).isActive = true
            middleReelRight.heightAnchor.constraint(equalTo: middleReelRight.widthAnchor).isActive = true
            middleReelRight.bottomAnchor.constraint(equalTo: bottomReelRight.topAnchor, constant: -screenSize.width/12).isActive = true
            middleReelRight.leadingAnchor.constraint(equalTo: middleReelCenter.trailingAnchor, constant: screenSize.width/11).isActive = true
            
            
            if self.line == ReelLine.triple {
                let topReelCenter = ReelCharacter(frame: .zero)
                topReelCenter.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(topReelCenter)
                let topReelLeft = ReelCharacter(frame: .zero)
                topReelLeft.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(topReelLeft)
                let topReelRight = ReelCharacter(frame: .zero)
                topReelRight.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(topReelRight)
                self.reelChars.insert(topReelRight, at: 0)
                self.reelChars.insert(topReelCenter, at: 0)
                self.reelChars.insert(topReelLeft, at: 0)
                
                topReelCenter.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                topReelCenter.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/6).isActive = true
                topReelCenter.heightAnchor.constraint(equalTo: topReelCenter.widthAnchor).isActive = true
                topReelCenter.bottomAnchor.constraint(equalTo: middleReelCenter.topAnchor, constant: -screenSize.width/12).isActive = true
                topReelLeft.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/6).isActive = true
                topReelLeft.heightAnchor.constraint(equalTo: topReelLeft.widthAnchor).isActive = true
                topReelLeft.bottomAnchor.constraint(equalTo: middleReelLeft.topAnchor, constant: -screenSize.width/12).isActive = true
                topReelLeft.trailingAnchor.constraint(equalTo: topReelCenter.leadingAnchor, constant: -screenSize.width/11).isActive = true
                topReelRight.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/6).isActive = true
                topReelRight.heightAnchor.constraint(equalTo: topReelRight.widthAnchor).isActive = true
                topReelRight.bottomAnchor.constraint(equalTo: middleReelRight.topAnchor, constant: -screenSize.width/12).isActive = true
                topReelRight.leadingAnchor.constraint(equalTo: topReelCenter.trailingAnchor, constant: screenSize.width/11).isActive = true
            }
        }
        
    }
}

enum ReelLine {
    case single
    case double
    case triple
    
    var frameImage: UIImage? {
        switch self {
        case .single:
            return UIImage(named: "reel_frame_single")
        case .double:
            return UIImage(named: "reel_frame_double")
        case .triple:
            return UIImage(named: "reel_frame_triple")
        }
    }
    
    var numberOfCharacter: Int {
        switch self {
        case .single:
            return 3
        case .double:
            return 6
        case .triple:
            return 9
        }
    }
}
