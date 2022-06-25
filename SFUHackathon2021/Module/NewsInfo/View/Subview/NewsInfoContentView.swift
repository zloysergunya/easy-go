import UIKit
import SnapKit

class NewsInfoContentView: RootView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratSemiBold(size: 24.0)
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    let addToCalendarButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить в календарь", for: .normal)
        button.setTitleColor(R.color.blue(), for: .normal)
        button.titleLabel?.font = R.font.montserratSemiBold(size: 13.0)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    let howToGetHereLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratMedium(size: 13.0)
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    let miniMapView: MiniMapView = {
        let view = MiniMapView()
        view.isHidden = true
        
        return view
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratRegular(size: 13.0)
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    private lazy var rootStack = UIStackView(views: [
        titleLabel,
        addToCalendarButton,
        howToGetHereLabel,
        miniMapView,
        textLabel
    ], spacing: 16.0, distribution: .fill)

    override func setup() {
        backgroundColor = .white
        
        rootStack.setCustomSpacing(0.0, after: titleLabel)
        
        addSubview(imageView)
        addSubview(rootStack)
        
        super.setup()
    }
    
    override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(168.0)
        }
        
        miniMapView.snp.makeConstraints { make in
            make.height.equalTo(160.0)
        }
        
        rootStack.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview()
        }
    }
    
}
