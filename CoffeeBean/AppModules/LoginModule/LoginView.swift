
import UIKit
import SnapKit

protocol LoginViewProtocol: AnyObject {
    var presenter: LoginPresenterProtocol {get set}
}

final class LoginView: UIViewController, LoginViewProtocol{

    var presenter: LoginPresenterProtocol = LoginPresenter()
    
    private let emailTextField: CustomTextFieldView = {
        let view = CustomTextFieldView(labelTextField: "e-mail", placeholder: "example@example.ru", isPassword: false)
        return view
    }()
    
    private let passwordTextField: CustomTextFieldView = {
        let view = CustomTextFieldView(labelTextField: "Пароль", placeholder: "******", isPassword: true)
        return view
    }()
    
    private lazy var signUpBtn: UIButton = {
        let view = UIButton()
        view.setTitle("Войти", for: .normal)
        view.setTitleColor(textColorBtn, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.backgroundColor = backgroundColorBtn
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return view
    }()
    
    private lazy var toRegViewBtn: UIButton = {
        let view = UIButton()
        view.setTitle("Еще нет аккаунта?", for: .normal)
        view.setTitleColor(.systemBlue, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        view.addTarget(self, action: #selector(toRegViewTapped), for: .touchUpInside)
        return view
    }()
    
    //MARK: - OVERRIDE FUNCS
    
    override func loadView() {
        super.loadView()
        settings()
        view.backgroundColor = .white
        navigationItem.title = "Вход"
        hideKeyboardWhenTappedAround()
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if (UserDefaults.standard.object(forKey: "login") != nil) {
//            print("not deleted")
//            print(UserDefaults.standard.object(forKey: "login") as! String)
//        } else {
//            print("all deleted")
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createAnchors()
    }
    
    //MARK: - SETTING FUNCS
    
    private func settings() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpBtn)
        view.addSubview(toRegViewBtn)
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
        
        signUpBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(19)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.height.equalTo(48)
        }
        
        toRegViewBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(19)
            make.top.equalTo(signUpBtn.snp.bottom).offset(10)
            make.height.equalTo(48)
        }
    }
    
    @objc func signUpTapped() {
        self.signUpBtn.zoomInWithEasing()
        self.presenter.auth(login: emailTextField.customTextField.text ?? "", password: passwordTextField.customTextField.text ?? "") { [weak self] data in
            if data.status {
                self?.presenter.goToMainListView()
            } else {
                print(data.message)
                let alert = UIAlertController(title: "Ошибка авторизации!", message: data.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        }
    }
    
    @objc func toRegViewTapped() {
        self.toRegViewBtn.zoomInWithEasing()
        self.presenter.goToRegView()
    }
}
