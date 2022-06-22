import UIKit
import SnapKit

class SettingsView: RootView {
    
    let navBar: NavBar = {
        let navBar = NavBar()
        navBar.titleLabel.text = "Настройки"
        
        return navBar
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    let contentView = SettingsContentView()

    override func setup() {
        
        backgroundColor = R.color.lightGrey()
        
        addSubview(scrollView)
        addSubview(navBar)
        
        scrollView.addSubview(contentView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        navBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
}
