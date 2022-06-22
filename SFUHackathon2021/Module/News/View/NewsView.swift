import UIKit
import SnapKit

class NewsView: RootView {
    
    let navBar: NavBar = {
        let navBar = NavBar()
        navBar.titleLabel.text = "Новости"
        
        return navBar
    }()
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.contentInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 16.0, right: 0.0)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        
        return view
    }()

    override func setup() {
        backgroundColor = R.color.lightGrey()
        
        addSubview(navBar)
        addSubview(collectionView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        navBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
}
