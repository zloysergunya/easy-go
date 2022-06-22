import UIKit
import SnapKit

class SettingsActionView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratRegular(size: 13.0)
        label.textColor = R.color.darkGrey()
        
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.montserratRegular(size: 11.0)
        label.textColor = R.color.darkGrey()
        
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: R.image.chevronRight())
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 60.0)
    }
    
    private lazy var labelsStack = UIStackView(views: [
        titleLabel,
        subtitleLabel
    ], spacing: 2.0, distribution: .fillProportionally)
    
    private lazy var rootStack = UIStackView(views: [
        labelsStack,
        imageView
    ], axis: .horizontal, spacing: 8.0, distribution: .fillProportionally)

    init(title: String, subtitle: String?) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        isUserInteractionEnabled = true
        
        titleLabel.text = title
        titleLabel.font = subtitle == nil ? R.font.montserratRegular(size: 13.0) : R.font.montserratMedium(size: 13.0)
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle == nil
        
        addSubview(rootStack)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        rootStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16.0)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(24.0)
        }
    }
    
}
