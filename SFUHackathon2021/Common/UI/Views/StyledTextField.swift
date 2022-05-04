import UIKit

class StyledTextField: UITextField {

    let padding = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
    
    override var placeholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.foregroundColor: R.color.darkGrey() ?? .darkGray,
                                                                                               .font: font ?? .systemFont(ofSize: 12.0)])
        }
    }
    
    override var leftView: UIView? {
        didSet {
            leftViewMode = .always
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 48.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = R.font.montserratRegular(size: 12.0)
        backgroundColor = .white
        textColor = R.color.darkGrey()
        layer.cornerRadius = 24.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

}
