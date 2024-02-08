
import Foundation

protocol MainListPresenterProtocol: AnyObject {
    var view: MainListViewProtocol? {get set}
    var interactor: MainListInteractorProtocol? {get set}
    var router: MainListRouterProtocol? {get set}
    
    func viewDidLoad()
    func goToMenuView(id: Int)
    func goToMapView(locations: [LocationModel])
    
    func interactorWithData(result: Result<[LocationModel], Error>)
    func quitFromApp()
}

final class MainListPresenter: MainListPresenterProtocol {

    weak var view: MainListViewProtocol?
    
    var interactor: MainListInteractorProtocol?
    
    var router: MainListRouterProtocol?

    func viewDidLoad() {
        interactor?.getLocationsData()
    }
    
    func interactorWithData(result: Result<[LocationModel], Error>) {
        switch (result) {
        case .success(let locations):
            view?.update(with: locations)
        case .failure(let error):
            print(error.localizedDescription)
            view?.update(with: "Try again later...")
        }
    }
    
    func goToMenuView(id: Int) {
        router?.goToMenuView(id: id)
    }
    
    func goToMapView(locations: [LocationModel]) {
        router?.goToMapView(locations: locations)
    }
    
    func quitFromApp() {
        interactor?.quit()
        router?.goToStartView()
    }
    
}
