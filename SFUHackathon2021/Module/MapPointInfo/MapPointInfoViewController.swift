import UIKit
import OverlayContainer
import Atributika

class MapPointInfoViewController: ViewController<MapPointInfoView> {
    
    private let feature: Feature
    private let elements: [Element]
    
    init(feature: Feature, elements: [Element]) {
        self.feature = feature
        self.elements = elements
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        configure()
    }
    
    private func configure() {
        mainView.nameLabel.text = "Перекрёсток"
        
        var text = ""
        if feature.properties.characteristics.count > 0 {
            feature.properties.characteristics.forEach { char in
                if let element = elements.first(where: { $0.id == char }) {
                    text.append(element.name + "\n")
                }
            }
        } else {
            text = "Нет информации"
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.0
        
        let p = Style().paragraphStyle(paragraphStyle)
        
        mainView.elementsLabel.attributedText = text.styleAll(p).attributedString
    }

    @objc private func close() {
        dismiss(animated: true)
    }
    
}

// MARK: - OverlayContainerViewControllerDelegate
extension MapPointInfoViewController: OverlayContainerViewControllerDelegate {
    
    enum OverlayNotch: Int, CaseIterable {
        case medium, maximum
    }

    func numberOfNotches(in containerViewController: OverlayContainerViewController) -> Int {
        return OverlayNotch.allCases.count
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        heightForNotchAt index: Int,
                                        availableSpace: CGFloat) -> CGFloat {
        switch OverlayNotch.allCases[index] {
        case .maximum: return availableSpace - mainView.safeAreaInsets.top
        case .medium: return availableSpace - 500.0
        }
    }
    
}
