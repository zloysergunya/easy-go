import Foundation

struct OnboardingConfig {
    
    static let allPages = [
        OnboardingSectionModel(title: "Отлично!\nТеперь подробнее",
                         image: R.image.onboardingPage1()),
        OnboardingSectionModel(title: "Если вам нужна помощь -\nпотрясите телефон",
                         image: R.image.onboardingPage2()),
        OnboardingSectionModel(title: "Будьте милосердны!\nПомогайте!",
                         image: R.image.onboardingPage3())
    ]
    
}
