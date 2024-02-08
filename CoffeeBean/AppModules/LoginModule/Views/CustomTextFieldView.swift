
import UIKit
import SnapKit

class CustomTextFieldView: UIView {

    private var labelTextField: String
    private var placeholder: String
    private var isPassword: Bool
    
    private lazy var customLabel: UILabel = {
        let view = UILabel()
        view.text = self.labelTextField
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = mainColor
        view.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return view
    }()
    
    lazy var customTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        view.layer.cornerRadius = 20
        view.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        view.layer.borderWidth = 2
        view.layer.borderColor = mainColor.cgColor
        view.layer.masksToBounds = true
        view.textColor = mainColor
        view.attributedPlaceholder = NSAttributedString(string: self.placeholder, attributes: [NSAttributedString.Key.foregroundColor: mainColor])
        view.isSecureTextEntry = isPassword
        return view
    }()

    init(labelTextField: String, placeholder: String, isPassword: Bool) {
        self.labelTextField = labelTextField
        self.placeholder = placeholder
        self.isPassword = isPassword
        super.init(frame: .zero)
        settings()
        createAnchors()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func settings() {
        self.addSubview(customLabel)
        self.addSubview(customTextField)
    }
    
    func createAnchors(){
        customLabel.snp.makeConstraints { label in
            label.leading.trailing.equalToSuperview()
            label.top.equalToSuperview()
            label.height.equalTo(18)
        }
        
        customTextField.snp.makeConstraints { textField in
            textField.leading.trailing.equalToSuperview()
            textField.top.equalTo(customLabel.snp.bottom).inset(-8)
            textField.height.equalTo(47)
        }
    }
}
