import UIKit

class WeatherView: UIView {
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratMedium(size: 18.0)
        label.textColor = R.color.darkGrey()
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratMedium(size: 18.0)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var rootView = UIStackView(views: [
        temperatureLabel,
        descriptionLabel
    ], axis: .horizontal, spacing: 8.0, distribution: .fillProportionally)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 8.0
        
        addSubview(rootView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        rootView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8.0)
            make.top.bottom.equalToSuperview().inset(12.0)
        }
    }
    
}
