import UIKit
import MapKit
import OverlayContainer

class MapViewController: ViewController<MapView> {
    
    private let provider = MapProdiver()
    private let locationManager = CLLocationManager()
    private let regionInMeters: Double = 500.0
    private var features: [Feature] = []
    private var mapElements: [Element] = []
    
    private var pointFrom: Point?
    private var pointTo: Point?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.routeButton.addTarget(self, action: #selector(getRoute), for: .touchUpInside)
        mainView.centerMapButton.addTarget(self, action: #selector(centerViewOnUserLocation), for: .touchUpInside)
        mainView.setCurrentLocationButton.addTarget(self, action: #selector(setUserLocationToField), for: .touchUpInside)
        
        mainView.fromField.delegate = self
        mainView.toField.delegate = self
        mainView.mapKitView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        loadPoints()
        loadElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func loadPoints() {
        provider.loadPoints { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let features):
                self.features = features
                features.forEach { self.createPoint(feature: $0) }
                
            case .failure: break
            }
        }
    }
    
    private func loadElements() {
        provider.loadElements { [weak self] result in
            switch result {
            case .success(let mapElements): self?.mapElements = mapElements
            case .failure: break
            }
        }
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            mainView.mapKitView.setUserTrackingMode(.follow, animated: true)
            checkLocationAuthorization()
        } else {
            openSettings()
        }
    }
    
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mainView.mapKitView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            
        case .denied: openSettings()
        case .notDetermined: locationManager.requestWhenInUseAuthorization()
        case .restricted: break
            
        case .authorizedAlways:
            mainView.mapKitView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            
        @unknown default: fatalError()
        }
    }
    
    private func updateRouteButtonState() {
        if pointFrom != nil && pointTo != nil {
            mainView.routeButton.backgroundColor = R.color.blue()
            mainView.routeButton.isUserInteractionEnabled = true
        }
    }
    
    private func createRoure(points: [Points]) {
        mainView.mapKitView.removeOverlays(mainView.mapKitView.overlays)
        let coordinates = points.map({ $0.points.coordinates.compactMap({ CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0]) }) })
        coordinates.forEach {
            let polyline = MKPolyline(coordinates: $0, count: $0.count)
            mainView.mapKitView.addOverlay(polyline)
        }
        
        if let startPoint = coordinates.first?.first {
            let center = CLLocationCoordinate2D(latitude: startPoint.latitude, longitude: startPoint.longitude)
            let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mainView.mapKitView.setRegion(region, animated: true)
        }
    }
    
    private func createPoint(feature: Feature) {
        let mapPoint = MapPoint()
        mapPoint.coordinate = CLLocationCoordinate2D(latitude: feature.geometry.coordinates[1], longitude: feature.geometry.coordinates[0])
        mapPoint.feature = feature
        mainView.mapKitView.addAnnotation(mapPoint)
    }
    
    @objc private func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mainView.mapKitView.setRegion(region, animated: true)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
    
    @objc private func getRoute(_ sender: UIButton) {
        Animations.press(view: sender)
        
        guard let pointFrom = pointFrom else {
            Animations.shake(view: mainView.fromField)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }
        
        guard let pointTo = pointTo else {
            Animations.shake(view: mainView.toField)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }
        
        provider.getRoute(pointFrom: [pointFrom.lat, pointFrom.lng], pointTo: [pointTo.lat, pointTo.lng]) { [weak self] result in
            switch result {
            case .success(let points):
                self?.createRoure(points: points)
                
            case .failure:
                break
            }
        }
    }
    
    @objc private func setUserLocationToField(_ sender: UIButton) {
        guard let location = locationManager.location?.coordinate else {
            return
        }
        
        pointFrom = Point(lat: location.latitude, lng: location.longitude)
        mainView.fromField.text = "Моё местоположение"
        updateRouteButtonState()
    }
    
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        annotationView.image = R.image.crossroads()
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        Animations.press(view: view)
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        guard let mapPoint = view.annotation as? MapPoint,
              let feature = mapPoint.feature else {
            return
        }
        
        let mapPointInfoViewController = MapPointInfoViewController(feature: feature, elements: mapElements)
        let container = OverlayContainerViewController(style: .flexibleHeight)
        container.transitioningDelegate = self
        container.modalPresentationStyle = .custom
        container.delegate = mapPointInfoViewController
        container.viewControllers = [mapPointInfoViewController]
        present(container, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKPolyline.self) {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.fillColor = .blue
            polylineRenderer.strokeColor = .blue
            polylineRenderer.lineWidth = 5.0
            
            return polylineRenderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
    
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate
extension MapViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return OverlayContainerSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
    
}

// MARK: - UITextFieldDelegate
extension MapViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let viewController: AddressSearchViewController
        
        if textField == mainView.fromField {
            viewController = AddressSearchViewController(searchPointType: .from, region: mainView.mapKitView.region)
        } else {
            viewController = AddressSearchViewController(searchPointType: .to, region: mainView.mapKitView.region)
        }
        
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
}

// MARK: - AddressSearchViewControllerDelegate
extension MapViewController: AddressSearchViewControllerDelegate {
    
    func addressSearchViewController(_ controller: AddressSearchViewController, didSearch hit: Hit) {
        var title = hit.name
        if let houseNumber = hit.housenumber {
            title.append(", " + houseNumber)
        }
        
        if let city = hit.city {
            title.append(", " + city)
        }
        
        switch controller.searchPointType {
        case .from:
            pointFrom = hit.point
            mainView.fromField.text = title
            
        case .to:
            pointTo = hit.point
            mainView.toField.text = title
        }
        
        updateRouteButtonState()
    }
    
}
