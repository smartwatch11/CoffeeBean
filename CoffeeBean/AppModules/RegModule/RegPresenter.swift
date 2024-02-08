
import Foundation

protocol RegPresenterProtocol: AnyObject {
    var view: RegViewProtocol? {get set}
    var interactor: RegInteractorProtocol? {get set}
    var router: RegRouterProtocol? {get set}
    
    func reg(login: String, password: String, repeatPassword: String, complition: @escaping ((status:Bool, message: String))->() )
    func goToMainView()
}

final class RegPresenter: RegPresenterProtocol {

    weak var view: RegViewProtocol?
    
    var interactor: RegInteractorProtocol?
    
    var router: RegRouterProtocol?

    
    func goToMainView() {
        self.router?.goToMainView()
    }
    
    func reg(login: String, password: String, repeatPassword: String, complition: @escaping ((status:Bool, message: String))->() ){
        self.interactor?.register(login: login, password: password, repeatPassword: repeatPassword) { data in
            complition(data)
        }
    }
    
}
