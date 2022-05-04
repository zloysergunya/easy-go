import UIKit
import SnapKit

class AddressSearchView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratBold(size: 18.0)
        label.textAlignment = .center
        label.textColor = UIColor(hex: 0x8690A6)
        
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(hex: 0x8690A6)
        
        return button
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.font = R.font.montserratMedium(size: 16.0)
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .black
        searchBar.barTintColor = R.color.foreground()
        
        return searchBar
    }()
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.contentInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 16.0, right: 0.0)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.keyboardDismissMode = .onDrag
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 32.0
        
        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(searchBar)
        addSubview(collectionView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(24.0)
            make.right.equalToSuperview().offset(-24.0)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24.0)
            make.right.equalToSuperview().offset(-24.0)
            make.size.equalTo(18.0)
        }

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(16.0)
            make.left.equalToSuperview().offset(8.0)
            make.right.equalToSuperview().offset(-8.0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
}
