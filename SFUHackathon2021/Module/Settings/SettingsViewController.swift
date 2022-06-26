import UIKit

class SettingsViewController: ViewController<SettingsView> {
    
    
    @Autowired
    private var authService: AuthService?

    override func viewDidLoad() {
        super.viewDidLoad()
     
        mainView.contentView.appInstructionActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openOnboarding)))
        mainView.contentView.exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc private func openOnboarding() {
        let viewController = OnboardingViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func exit() {
        dialog(title: "Вы действительно хотите сбросить свои данные?",
               accessText: "Сбросить данные",
               cancelText: "Отмена",
               onAgree: { [weak self] _ in
            self?.authService?.deauthorize()
        }, preferredStyle: .actionSheet)

    }
    
}
