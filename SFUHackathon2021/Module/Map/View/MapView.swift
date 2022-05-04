import UIKit
import SnapKit
import MapKit

class MapView: UIView {
    
    private let topTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Укажите маршрут"
        label.font = R.font.montserratRegular(size: 24.0)
        label.textColor = .black
        
        return label
    }()

     lazy var topRoundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 32.0
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        view.addSubview(topTitleLabel)
        
        return view
    }()
    
    let mapKitView: MKMapView = {
        let mapView = MKMapView()
        
        return mapView
    }()
    
    let fromField: StyledTextField = {
        let textField = StyledTextField()
        textField.placeholder = "Откуда"
        
        return textField
    }()
    
    let toField: StyledTextField = {
        let textField = StyledTextField()
        textField.placeholder = "Куда"
        
        return textField
    }()
    
    let routeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Построить маршрут", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = R.font.montserratMedium(size: 14.0)
        button.backgroundColor = R.color.foregroundContrast()
        button.layer.cornerRadius = 16.0
        
        return button
    }()
    
    let centerMapButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.tintColor = UIColor(hex: 0xC4C4C4)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25.0
        
        return button
    }()
    
     lazy var bottomRoundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 32.0
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view.addSubview(fromField)
        view.addSubview(toField)
        view.addSubview(routeButton)
                
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(mapKitView)
        addSubview(topRoundView)
        addSubview(bottomRoundView)
        addSubview(centerMapButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        topRoundView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(108.0)
        }
        
        topTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16.0)
        }
        
        mapKitView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomRoundView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(221.0)
        }
        
        fromField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24.0)
            make.left.equalToSuperview().offset(54.0)
            make.right.equalToSuperview().offset(-54.0)
            make.height.equalTo(40.0)
        }
        
        toField.snp.makeConstraints { make in
            make.top.equalTo(fromField.snp.bottom).offset(16.0)
            make.left.equalToSuperview().offset(54.0)
            make.right.equalToSuperview().offset(-54.0)
            make.height.equalTo(40.0)
        }
        
        routeButton.snp.makeConstraints { make in
            make.top.equalTo(toField.snp.bottom).offset(24.0)
            make.left.equalToSuperview().offset(68.0)
            make.right.equalToSuperview().offset(-68.0)
            make.height.equalTo(32.0)
        }
        
        centerMapButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.bottom.equalTo(bottomRoundView.snp.top).offset(-16.0)
            make.size.equalTo(50.0)
        }
        
    }
    
}
