import UIKit
import Atributika
import MapKit
import EventKit

class NewsInfoViewController: ViewController<NewsInfoView> {
    
    private let news: News
    private let eventStore = EKEventStore()
    
    init(news: News) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        mainView.contentView.addToCalendarButton.addTarget(self, action: #selector(addToCalendar), for: .touchUpInside)
        mainView.contentView.miniMapView.makeRouteButton.addTarget(self, action: #selector(createRoute), for: .touchUpInside)
        
        configure()
    }
    
    private func configure() {
        ImageLoader.setImage(url: news.image, imgView: mainView.contentView.imageView)
        mainView.contentView.titleLabel.text = news.title
        mainView.contentView.textLabel.text = news.text
        
        mainView.contentView.addToCalendarButton.isHidden = news.point == nil
        
        if let nowToGetHere = news.howToGetHere {
            let semiBold = Style("semiBold").font(R.font.montserratSemiBold(size: 13.0) ?? .systemFont(ofSize: 13.0, weight: .semibold))
            let text = "<semiBold>Как добраться:</semiBold> " + nowToGetHere
            mainView.contentView.howToGetHereLabel.attributedText = text.style(tags: semiBold).attributedString
        }
        mainView.contentView.howToGetHereLabel.isHidden = news.howToGetHere == nil
        
        if let point = news.point {
            let regionInMeters: Double = 600.0
            let coordinate = CLLocationCoordinate2D(latitude: point.lat, longitude: point.lng)
            let region = MKCoordinateRegion(center: coordinate,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            mainView.contentView.miniMapView.mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mainView.contentView.miniMapView.mapView.addAnnotation(annotation)
        }
        mainView.contentView.miniMapView.isHidden = news.point == nil
    }
    
    @objc private func addToCalendar() {
        Utils.impactFeedback()
        
        eventStore.requestAccess(to: .event) { [weak self] granted, error in
            if let error = error, !granted {
                log.error(error.localizedDescription)
                
                return
            }
            
            guard let self = self else { return }
            
            let event = EKEvent(eventStore: self.eventStore)
            event.title = self.news.title
            event.notes = self.news.text
            event.startDate = self.news.date
            event.endDate = self.news.date?.add(.day, value: 1)
            event.calendar = self.eventStore.defaultCalendarForNewEvents
            
            do {
                try self.eventStore.save(event, span: .thisEvent, commit: true)
                DispatchQueue.main.async {
                    self.mainView.contentView.addToCalendarButton.isHidden = true
                }
            } catch {
                log.error(error.localizedDescription)
            }
        }
    }
    
    @objc private func createRoute() {
        guard let tabBarController = Utils.tabBarController(), let point = news.point else {
            return
        }
        
        tabBarController.selectedIndex = 1
        NotificationCenter.default.post(name: MapViewController.createRouteNotification, object: point)
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    
}
