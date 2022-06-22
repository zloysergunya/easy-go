import UIKit
import SnapKit

class NewsCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8.0
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratSemiBold(size: 15.0)
        label.textColor = .black
        
        return label
    }()
    
    let eventLabel: UILabel = {
        let label = UILabel()
        label.text = "Событие"
        label.font = R.font.montserratSemiBold(size: 13.0)
        label.textColor = R.color.blue()
        label.isHidden = true
        
        return label
    }()
    
    private lazy var labelsStack = UIStackView(views: [
        titleLabel,
        eventLabel
    ])
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratRegular(size: 13.0)
        label.textColor = .black
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        contentView.addSubview(imageView)
        contentView.addSubview(labelsStack)
        contentView.addSubview(textLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(8.0)
            make.size.equalTo(84.0)
        }
        
        labelsStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10.0)
            make.left.equalTo(imageView.snp.right).offset(12.0)
            make.right.equalToSuperview().inset(16.0)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(labelsStack.snp.bottom).offset(4.0)
            make.left.equalTo(imageView.snp.right).offset(12.0)
            make.right.bottom.equalToSuperview().inset(16.0)
        }
    }
    
}
