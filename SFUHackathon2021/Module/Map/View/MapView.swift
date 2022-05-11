import UIKit
import SnapKit
import MapKit

class MapView: RootView {
    
    private let topTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Укажите маршрут"
        label.font = R.font.montserratMedium(size: 20.0)
        label.textColor = .black
        
        return label
    }()

     let topRoundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 32.0
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        return view
    }()
    
    let mapKitView: MKMapView = {
        let mapView = MKMapView()
        
        return mapView
    }()
    
    let setCurrentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "location.fill"), for: .normal)
        button.tintColor = UIColor(hex: 0xC4C4C4)
        
        return button
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
        button.backgroundColor = R.color.lightBlue()
        button.layer.cornerRadius = 24.0
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    let centerMapButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.tintColor = UIColor(hex: 0xC4C4C4)
        button.backgroundColor = .white
        button.layer.cornerRadius = 24.0
        
        return button
    }()
    
     let bottomRoundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 32.0
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
 
        return view
    }()
    
    override func setup() {
        
        addSubview(mapKitView)
        addSubview(topRoundView)
        addSubview(bottomRoundView)
        addSubview(centerMapButton)
        
        topRoundView.addSubview(topTitleLabel)
        
        bottomRoundView.addSubview(fromField)
        bottomRoundView.addSubview(toField)
        bottomRoundView.addSubview(routeButton)
        
        fromField.addSubview(setCurrentLocationButton)
        
        super.setup()
    }
    
    override func setupConstraints() {
        topRoundView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        topTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20.0)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20.0)
        }
        
        mapKitView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomRoundView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        fromField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24.0)
            make.left.right.equalToSuperview().inset(24.0)
        }
        
        setCurrentLocationButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(24.0)
        }
        
        toField.snp.makeConstraints { make in
            make.top.equalTo(fromField.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(24.0)
        }
        
        routeButton.snp.makeConstraints { make in
            make.top.equalTo(toField.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview().inset(24.0)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-8.0)
            make.height.equalTo(48.0)
        }
        
        centerMapButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.bottom.equalTo(bottomRoundView.snp.top).offset(-16.0)
            make.size.equalTo(48.0)
        }
    }
    
}
