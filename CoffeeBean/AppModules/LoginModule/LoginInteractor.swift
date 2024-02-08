
import Foundation

protocol LoginInteractorProtocol: AnyObject {
    var presenter: LoginPresenterProtocol? {get set}
    
    func auth(login: String, password: String, complition: @escaping ((status:Bool, message: String))->())
}

final class LoginInteractor: LoginInteractorProtocol {
    weak var presenter: LoginPresenterProtocol?
    
    private let networkManager: LoginNetworkManagerProtocol
    
    init(networkManager: LoginNetworkManagerProtocol = LoginNetworkManager()) {
        self.networkManager = networkManager
    }
    
    func auth(login: String, password: String, complition: @escaping ((status:Bool, message: String))->()) {
        
        if !isValid("e", login) {
            complition((status: false, message: "E-mail должен соответствовать шаблону example@example.ru"))
        } else if !isValid("p", password) {
            complition((status: false, message: "Пароль должен состоять минимум из 6 символов латинского алфавита или цифр"))
        }
        
        networkManager.userAuth(login: login, password: password) { data in
            if (data.token != nil) {
                UserDefaults.standard.set(login, forKey: "login")
                do{
                    let status = try KeychainManager.savePassword(password: password.data(using: .utf8) ?? Data(), login: login)
                    let passData = try KeychainManager.getPassword(for: login)
                    let status2 = String(decoding: passData ?? Data(), as: UTF8.self)
                    
                    let status3 = try KeychainManager.saveToken(token: ((data.token?.data(using: .utf8) ?? String().data(using: .utf8))!), login: login)
                    let passData2 = try KeychainManager.getToken(for: login)
                    let status4 = String(decoding: passData2 ?? Data(), as: UTF8.self)
                    
                } catch {
                    print(error.localizedDescription)
                    complition((status: false, message: "Неизвестная ошибка"))
                }
                complition((status: true, message: "Авторизация прошла успешно"))
            } else {
                complition((status: false, message: "Во время авторизации возникла ошибка"))
            }
        }
    }
    
    private func isValid(_ type: String, _ data: String) -> Bool{
        var dataRegEx = ""
        switch type {
        case "e":
            dataRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        default:
            dataRegEx = "(?=.*[A-Z0-9a-z]).{6,}"
        }
        let dataPred = NSPredicate(format:"SELF MATCHES %@", dataRegEx)
        return dataPred.evaluate(with: data)
    }
    
}
