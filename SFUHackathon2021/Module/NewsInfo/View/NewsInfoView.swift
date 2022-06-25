import UIKit
import SnapKit

class NewsInfoView: RootView {
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.back36(), for: .normal)
        button.tintColor = R.color.lightBlue()
        button.backgroundColor = .white
        button.layer.cornerRadius = 18.0
        
        return button
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    let contentView = NewsInfoContentView()

    override func setup() {
        backgroundColor = .white
        
        addSubview(scrollView)
        addSubview(closeButton)
        scrollView.addSubview(contentView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(14.0)
            make.left.equalToSuperview().offset(8.0)
            make.size.equalTo(36.0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
}
