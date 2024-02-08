
import Foundation

protocol CartPresenterProtocol: AnyObject {
    var view: CartViewProtocol? {get set}
    var interactor: CartInteractorProtocol? {get set}
    var router: CartRouterProtocol? {get set}
    
    func viewDidLoad()
    func goToMainView()
    
    func interactorUpdateData(cart: [Cart])
}

final class CartPresenter: CartPresenterProtocol {

    weak var view: CartViewProtocol?
    
    var interactor: CartInteractorProtocol?
    
    var router: CartRouterProtocol?

    func viewDidLoad() {
        interactor?.getCartData()
    }
    
    func interactorUpdateData(cart: [Cart]) {
        if cart.count > 0 {
            view?.update(with: cart)
        } else {
            view?.update(with: "Not exists data")
        }
    }
    
    func goToMainView() {
        router?.goToMainView()
    }
    
}
