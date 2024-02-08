
import Foundation
import UIKit

protocol LoginRouterProtocol {
    var entry: LoginView? {get}
    static func startExecution() -> LoginRouterProtocol
    func routeToRegisterView()
    func routeToMainListView()
}

final class LoginRouter: LoginRouterProtocol {
    
    var entry: LoginView?
    
    static func startExecution() -> LoginRouterProtocol {
        let router = LoginRouter()
        let view = LoginView()
        let presenter = LoginPresenter()
        let interactor = LoginInteractor()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        
        router.entry = view
        
        return router
    }
    
    func routeToRegisterView() {
        let regRouter = RegRouter.createRegistration()
        guard let regView = regRouter.entry else {return}
        guard let viewController = self.entry else {return}
        
        viewController.navigationController?.pushViewController(regView, animated: true)
    }
    
    func routeToMainListView() {
        let mainListRouter = MainListRouter.createMainList()
        guard let mainListView = mainListRouter.entry else {return}
        guard let viewController = self.entry else {return}
        
        viewController.navigationController?.setViewControllers([mainListView], animated: true)
    }
}
