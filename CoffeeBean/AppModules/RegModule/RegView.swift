
import UIKit
import SnapKit

protocol RegViewProtocol: AnyObject {
    var presenter: RegPresenterProtocol {get set}
}

final class RegView: UIViewController, RegViewProtocol{

    var presenter: RegPresenterProtocol = RegPresenter()
    
    private let emailTextField: CustomTextFieldView = {
        let view = CustomTextFieldView(labelTextField: "e-mail", placeholder: "example@example.ru", isPassword: false)
        return view
    }()
    
    private let passwordTextField: CustomTextFieldView = {
        let view = CustomTextFieldView(labelTextField: "Пароль", placeholder: "******", isPassword: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let repeatPasswordTextField: CustomTextFieldView = {
        let view = CustomTextFieldView(labelTextField: "Повторите пароль", placeholder: "******", isPassword: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var signUpBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Регистрация", for: .normal)
        view.setTitleColor(textColorBtn, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.backgroundColor = backgroundColorBtn
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return view
    }()
    
    //MARK: - OVERRIDE FUNCS
    
    override func loadView() {
        super.loadView()
        settings()
        view.backgroundColor = .white
        navigationItem.title = "Регистрация"
        hideKeyboardWhenTappedAround()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backToMainListView))
    }
    
    @objc private func backToMainListView() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createAnchors()
    }
    
    //MARK: - SETTING FUNCS
    
    private func settings() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(repeatPasswordTextField)
        view.addSubview(signUpBtn)
    }
    
    private func createAnchors(){
        
        emailTextField.snp.makeConstraints { textField in
            textField.leading.trailing.equalToSuperview().inset(18)
            textField.top.equalTo(view.snp.top).offset(278)
            textField.height.equalTo(73)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.height.equalTo(73)
        }
        
        repeatPasswordTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.height.equalTo(73)
        }
        
        signUpBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(19)
            make.top.equalTo(repeatPasswordTextField.snp.bottom).offset(30)
            make.height.equalTo(48)
        }
    }
    
    @objc func signUpTapped() {
        self.signUpBtn.zoomInWithEasing()
        self.presenter.reg(login: emailTextField.customTextField.text ?? "", password: passwordTextField.customTextField.text ?? "", repeatPassword: repeatPasswordTextField.customTextField.text ?? "") { [weak self] data in
            if data.status {
                self?.presenter.goToMainView()
            } else {
                print(data.message)
                let alert = UIAlertController(title: "Ошибка при регистрации!", message: data.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        }
    }
}
