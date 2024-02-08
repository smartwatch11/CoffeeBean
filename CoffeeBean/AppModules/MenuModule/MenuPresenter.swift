
import Foundation

protocol MenuPresenterProtocol: AnyObject {
    var view: MenuViewProtocol? {get set}
    var interactor: MenuInteractorProtocol? {get set}
    var router: MenuRouterProtocol? {get set}
    
    func viewDidLoad()
    func goToCartView()
    
    func interactorWithData(result: Result<[MenuModel], Error>)
}

final class MenuPresenter: MenuPresenterProtocol {

    weak var view: MenuViewProtocol?
    
    var interactor: MenuInteractorProtocol?
    
    var router: MenuRouterProtocol?

    func viewDidLoad() {
        interactor?.getItemsData()
    }
    
    func interactorWithData(result: Result<[MenuModel], Error>) {
        switch (result) {
        case .success(let items):
            view?.update(with: items)
        case .failure(let error):
            print(error.localizedDescription)
            view?.update(with: "Try again later...")
        }
    }
    
    func goToCartView() {
        router?.goToCartView()
    }
    
}
