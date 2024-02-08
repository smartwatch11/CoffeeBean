
import Foundation


protocol RegInteractorProtocol: AnyObject {
    var presenter: RegPresenterProtocol? {get set}
    
    func register(login: String, password: String, repeatPassword: String, complition: @escaping ((status:Bool, message: String))->())
}

final class RegInteractor: RegInteractorProtocol {
    
    weak var presenter: RegPresenterProtocol?
    
    private let networkManager: RegNetworkManagerProtocol
    
    init(networkManager: RegNetworkManagerProtocol = RegNetworkManager()) {
        self.networkManager = networkManager
    }
    
    func register(login: String, password: String, repeatPassword: String, complition: @escaping ((status: Bool, message: String)) -> ()) {
        if !isValid("e", login) {
            complition((status: false, message: "E-mail должен соответствовать шаблону example@example.ru"))
        } else if !isValid("p", password) {
            complition((status: false, message: "Пароль должен состоять минимум из 6 символов латинского алфавита или цифр"))
        } else if password != repeatPassword {
            complition((status: false, message: "Пароли должны сопадать"))
        } else {
            
            networkManager.userReg(login: login, password: password) { data in
                if (data.token != nil) {
                    UserDefaults.standard.set(login, forKey: "login")
                    do{
                        _ = try KeychainManager.savePassword(password: password.data(using: .utf8) ?? Data(), login: login)
                        let passData = try KeychainManager.getPassword(for: login)
                        _ = String(decoding: passData ?? Data(), as: UTF8.self)
                        
                        _ = try KeychainManager.saveToken(token: ((data.token?.data(using: .utf8) ?? String().data(using: .utf8))!), login: login)
                        let passData2 = try KeychainManager.getToken(for: login)
                        _ = String(decoding: passData2 ?? Data(), as: UTF8.self)
                        
                    } catch {
                        complition((status: false, message: "Во время проверки данных возникла ошибка"))
                    }
                    complition((status: true, message: "Регистрация прошла успешно"))
                } else {
                    complition((status: false, message: "Во время регистрации возникла ошибка"))
                }
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
