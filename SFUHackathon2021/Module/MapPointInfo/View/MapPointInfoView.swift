import UIKit
import SnapKit

class MapPointInfoView: RootView {
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = R.color.darkGrey()
        
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratSemiBold(size: 16.0)
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    let elementsLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratMedium(size: 14.0)
        label.textColor = R.color.darkGrey()
        label.numberOfLines = 0
        
        return label
    }()
    
    let undesirablePointButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(R.color.blue(), for: .normal)
        button.titleLabel?.font = R.font.montserratSemiBold(size: 13.0)
        
        return button
    }()

    override func setup() {
        backgroundColor = .white
        
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 32.0
        
        addSubview(closeButton)
        addSubview(nameLabel)
        addSubview(elementsLabel)
        addSubview(undesirablePointButton)
        
        super.setup()
    }
    
    override func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(24.0)
            make.size.equalTo(18.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(24.0)
            make.right.equalTo(closeButton.snp.left).inset(16.0)
        }
        
        elementsLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(24.0)
        }
        
        undesirablePointButton.snp.makeConstraints { make in
            make.top.equalTo(elementsLabel.snp.bottom).offset(24.0)
            make.left.equalToSuperview().inset(24.0)
            make.height.equalTo(24.0)
        }
    }
    
}
