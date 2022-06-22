import UIKit
import SnapKit

class SettingsSectionTitleView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratRegular(size: 13.0)
        label.textColor = R.color.darkGrey()
        
        return label
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 44.0)
    }

    init(title: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        
        addSubview(titleLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16.0)
        }
    }
    
}
