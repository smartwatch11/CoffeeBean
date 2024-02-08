
import Foundation
import UIKit

protocol RegRouterProtocol {
    var entry: RegView? {get}
    static func createRegistration() -> RegRouterProtocol
    func goToMainView()
}

final class RegRouter: RegRouterProtocol {

    var entry: RegView?
    
    static func createRegistration() -> RegRouterProtocol {
        let router = RegRouter()
        let view = RegView()
        let presenter = RegPresenter()
        let interactor = RegInteractor()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        
        router.entry = view
        
        return router
    }
    
    func goToMainView() {
        let mainListRouter = MainListRouter.createMainList()
        guard let mainListView = mainListRouter.entry else {return}
        guard let viewController = self.entry else {return}
        
        viewController.navigationController?.setViewControllers([mainListView], animated: true)
    }
}
