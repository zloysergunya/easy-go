import UIKit
import SnapKit

class OnboardingView: RootView {
    
    private let collectionLayout: UICollectionViewFlowLayout = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = 0.0
        collectionLayout.minimumInteritemSpacing = 0.0
        
        return collectionLayout
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Продолжить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = R.font.montserratSemiBold(size: 13.0)
        button.backgroundColor = R.color.blue()
        button.layer.cornerRadius = 24.0
        
        return button
    }()

    override func setup() {
        backgroundColor = R.color.lightBlue()
        
        addSubview(collectionView)
        addSubview(nextButton)
        
        super.setup()
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24.0)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-46.0)
            make.height.equalTo(48.0)
        }
    }
    
}
