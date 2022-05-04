import UIKit
import SnapKit

class AddressSearchCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratMedium(size: 16.0)
        label.textColor = .black
        
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratMedium(size: 14.0)
        label.textColor = UIColor(hex: 0x8690A6)
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = UIColor(hex: 0x8690A6)
        
        return imageView
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xC4C4C4)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(separator)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4.0)
            make.left.equalToSuperview().offset(16.0)
            make.right.equalTo(imageView.snp.left).offset(-16.0)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4.0)
            make.left.equalToSuperview().offset(16.0)
            make.right.equalTo(imageView.snp.left).offset(-16.0)
        }
        
        imageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(16.0)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1.0)
        }
        
    }
    
}
