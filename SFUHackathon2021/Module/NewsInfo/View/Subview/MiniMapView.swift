import UIKit
import SnapKit
import MapKit

class MiniMapView: RootView {
    
    let mapView = MKMapView()

    let makeRouteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Построить маршрут", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = R.color.blue()
        button.titleLabel?.font = R.font.montserratSemiBold(size: 13.0)
        button.layer.cornerRadius = 24.0
        
        return button
    }()
    
    override func setup() {
        isUserInteractionEnabled = true
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
        
        addSubview(mapView)
        addSubview(makeRouteButton)
        
        super.setup()
    }
    
    override func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        makeRouteButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(8.0)
            make.height.equalTo(48.0)
        }
    }
    
}
