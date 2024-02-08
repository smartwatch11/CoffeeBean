
import Foundation

protocol LoginPresenterProtocol: AnyObject {
    var view: LoginViewProtocol? {get set}
    var interactor: LoginInteractorProtocol? {get set}
    var router: LoginRouterProtocol? {get set}
    
    func goToRegView()
    func goToMainListView()
    func auth(login: String, password: String, complition: @escaping ((status:Bool, message: String))->())
}

final class LoginPresenter: LoginPresenterProtocol {
    
    weak var view: LoginViewProtocol?
    
    var interactor: LoginInteractorProtocol?
    
    var router: LoginRouterProtocol?
    
    func goToRegView() {
        self.router?.routeToRegisterView()
    }
    
    func goToMainListView() {
        self.router?.routeToMainListView()
    }
    
    func auth(login: String, password: String, complition: @escaping ((status:Bool, message: String))->() ){
        self.interactor?.auth(login: login, password: password) { data in
            complition(data)
        }
    }
    
}
