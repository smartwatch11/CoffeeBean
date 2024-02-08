
import Foundation
import UIKit

protocol CartRouterProtocol {
    var entry: CartView? {get}
    static func createCart(with cart: [Cart]) -> CartRouterProtocol
    func goToMainView()
}

final class CartRouter: CartRouterProtocol {

    var entry: CartView?
    
    static func createCart(with cart: [Cart]) -> CartRouterProtocol {
        let router = CartRouter()
        let view = CartView()
        let presenter = CartPresenter()
        let interactor = CartInteractor()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        interactor.cart = cart
        
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
