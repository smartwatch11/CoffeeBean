
import Foundation
import UIKit

protocol MainListRouterProtocol {
    var entry: MainListView? {get}
    static func createMainList() -> MainListRouterProtocol
    func goToMenuView(id: Int)
    func goToMapView(locations: [LocationModel])
    func goToStartView()
}

final class MainListRouter: MainListRouterProtocol {

    var entry: MainListView?
    
    static func createMainList() -> MainListRouterProtocol {
        let router = MainListRouter()
        let view = MainListView()
        let presenter = MainListPresenter()
        let interactor = MainListInteractor()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        
        router.entry = view
        
        return router
    }
    
    func goToMenuView(id: Int) {
        let menuRouter = MenuRouter.createMenu(id: id)
        guard let menuView = menuRouter.entry else {return}
        guard let viewController = self.entry else {return}
        
        viewController.navigationController?.pushViewController(menuView, animated: true)
    }
    
    func goToMapView(locations: [LocationModel]) {
        let mapView = MapView()
        mapView.locations = locations
        guard let viewController = self.entry else {return}
        
        viewController.navigationController?.pushViewController(mapView, animated: true)
    }
    
    func goToStartView() {
        guard let viewController = self.entry else {return}
        let router = LoginRouter.startExecution()
        let initialViewController = router.entry!
        
        viewController.navigationController?.setViewControllers([initialViewController], animated: true)
    }
}
