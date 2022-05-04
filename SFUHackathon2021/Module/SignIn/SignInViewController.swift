import UIKit

class SignInViewController: ViewController<SignInView> {
    
    private let provider = SignInProvider()
    private let specificsPicker = UIPickerView()
    
    @Autowired
    private var authService: AuthService?
    private var specifics: [Specific] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)

        specificsPicker.dataSource = self
        specificsPicker.delegate = self
        mainView.specificsField.inputView = specificsPicker
        
        loadSpecifics()
    }

    private func loadSpecifics() {
        mainView.specificsField.isUserInteractionEnabled = false
        provider.loadSpecifics() { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let specifics):
                self.specifics = specifics
                self.specificsPicker.reloadAllComponents()
                self.mainView.specificsField.isUserInteractionEnabled = true
                
            case .failure: break
            }
        }
    }
    
    @objc private func nextStep() {
        guard UserSettings.restrictionName != nil else {
            Animations.shake(view: mainView.nameField)
            Utils.impactErrorFeedback()
            
            return
        }
        
        guard let specific = UserSettings.specific else {
            Animations.shake(view: mainView.specificsField)
            Utils.impactErrorFeedback()
            
            return
        }
        
        authService?.authorize(with: specific)
    }
    
}

// MARK: - UIPickerViewDataSource
extension SignInViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return specifics.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = R.font.montserratMedium(size: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.text = specifics[row].name
        
        return label
    }
    
}

// MARK: - UIPickerViewDelegate
extension SignInViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mainView.specificsField.text = specifics[row].name
        UserSettings.specific = specifics[row].id
        UserSettings.restrictionName = specifics[row].name
    }
    
}
