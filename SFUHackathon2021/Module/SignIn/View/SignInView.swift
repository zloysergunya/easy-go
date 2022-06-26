import UIKit
import SnapKit

class SignInView: RootView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: R.image.signIn())
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratMedium(size: 24.0)
        label.textColor = .black
        label.text = "Привет! Это easy-go"
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratMedium(size: 13.0)
        label.textColor = R.color.blue()
        label.text = "Укажите ваши данные, чтобы продолжить"
        label.numberOfLines = 2
        
        return label
    }()
    
    let nameField: StyledTextField = {
        let textField = StyledTextField()
        textField.placeholder = "Название ограничения"
        
        return textField
    }()
    
    let specificsField: StyledTextField = {
        let textField = StyledTextField()
        textField.placeholder = "Специфика ограничения"
        
        return textField
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
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(nameField)
        addSubview(specificsField)
        addSubview(nextButton)
        
        super.setup()
    }
    
    override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(20.0)
            make.height.equalTo(369.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(30.0)
            make.left.right.equalToSuperview().inset(24.0)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(24.0)
        }
        
        nameField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(36.0)
            make.left.right.equalToSuperview().inset(24.0)
        }
        
        specificsField.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(24.0)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(specificsField.snp.bottom).offset(32.0)
            make.left.right.equalToSuperview().inset(24.0)
            make.height.equalTo(48.0)
        }
    }
    
}
