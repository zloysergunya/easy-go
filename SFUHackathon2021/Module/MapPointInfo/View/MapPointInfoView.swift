import UIKit
import SnapKit

class MapPointInfoView: UIView {
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(hex: 0x8690A6)
        
        return button
    }()
    
    private let nameTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratSemiBold(size: 14.0)
        label.textColor = UIColor(hex: 0x8690A6)
        label.text = "Название точки"
        
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratRegular(size: 14.0)
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    private let elementsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratSemiBold(size: 14.0)
        label.textColor = UIColor(hex: 0x8690A6)
        label.text = "Элементы безбарьерной среды"
        
        return label
    }()
    
    let elementsLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratRegular(size: 14.0)
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 32.0
        
        addSubview(closeButton)
        addSubview(nameTitleLabel)
        addSubview(nameLabel)
        addSubview(elementsTitleLabel)
        addSubview(elementsLabel)
        
        backgroundColor = .white
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24.0)
            make.right.equalToSuperview().offset(-24.0)
            make.size.equalTo(18.0)
        }
        
        nameTitleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(24.0)
            make.right.equalTo(closeButton.snp.left).offset(-24.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(8.0)
            make.left.equalToSuperview().offset(24.0)
            make.right.equalToSuperview().offset(-24.0)
        }
        
        elementsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(24.0)
            make.left.equalToSuperview().offset(24.0)
            make.right.equalToSuperview().offset(-24.0)
        }
        
        elementsLabel.snp.makeConstraints { make in
            make.top.equalTo(elementsTitleLabel.snp.bottom).offset(8.0)
            make.left.equalToSuperview().offset(24.0)
            make.right.equalToSuperview().offset(-24.0)
        }
        
    }
    
}
