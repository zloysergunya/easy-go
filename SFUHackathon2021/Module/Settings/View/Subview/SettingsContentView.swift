import UIKit
import SnapKit

class SettingsContentView: RootView {
    
    let restrictionActionView = SettingsActionView(title: "Ограничение", subtitle: "По зрению, двигательной активности")
    let healthAccessActionView = SettingsActionView(title: "Разрешение доступа к данным Здоровья", subtitle: nil)
    let undesirablePointsActionView = SettingsActionView(title: "Нежелательные точки построения маршрута", subtitle: nil)
    
    let supportActionView = SettingsActionView(title: "Поддержка", subtitle: nil)
    let reportAnErrorActionView = SettingsActionView(title: "Сообщить об ошибке", subtitle: nil)
    
    let appInstructionActionView = SettingsActionView(title: "Инструкция пользования приложением", subtitle: nil)
    
    let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сброс данных", for: .normal)
        button.setTitleColor(.init(hex: 0xE31E24), for: .normal)
        button.titleLabel?.font = R.font.montserratMedium(size: 13.0)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        
        return button
    }()
    
    private lazy var rootStack = UIStackView(views: [
        SettingsSectionTitleView(title: "Профиль"),
        restrictionActionView,
        healthAccessActionView,
        undesirablePointsActionView,
        SettingsSectionTitleView(title: "Обратная связь"),
        supportActionView,
        reportAnErrorActionView,
        SettingsSectionTitleView(title: "Прочее"),
        appInstructionActionView,
        exitButton
    ], distribution: .fill)

    override func setup() {
        
        addSubview(rootStack)
        
        super.setup()
    }
    
    override func setupConstraints() {
        rootStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        exitButton.snp.makeConstraints { make in
            make.height.equalTo(60.0)
        }
    }
    
}
