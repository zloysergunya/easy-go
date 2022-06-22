import UIKit
import SnapKit

class NavBar: RootView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = R.font.montserratMedium(size: 20.0)
        label.textAlignment = .center
        
        return label
    }()
    
    override func setup() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        
        super.setup()
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20.0)
            make.left.right.bottom.equalToSuperview().inset(20.0)
        }
    }
    
}
