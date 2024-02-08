
import Foundation
import UIKit

protocol MenuRouterProtocol {
    var entry: MenuView? {get}
    static func createMenu(id: Int) -> MenuRouterProtocol
    func goToCartView()
}

final class MenuRouter: MenuRouterProtocol {

    var entry: MenuView?
    
    static func createMenu(id: Int) -> MenuRouterProtocol {
        let router = MenuRouter()
        let view = MenuView()
        let presenter = MenuPresenter()
        let interactor = MenuInteractor()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        interactor.id = id
        
        router.entry = view
        
        return router
    }
    
    func goToCartView() {
        let cartRouter = CartRouter.createCart(with: self.entry?.cartItems ?? [])
        guard let cartView = cartRouter.entry else {return}
        guard let viewController = self.entry else {return}
        
        viewController.navigationController?.pushViewController(cartView, animated: true)
    }
}
