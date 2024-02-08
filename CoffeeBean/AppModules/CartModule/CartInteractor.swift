
import Foundation


protocol CartInteractorProtocol: AnyObject {
    var presenter: CartPresenterProtocol? {get set}
    var cart: [Cart]? {get set}
    func getCartData()
}

final class CartInteractor: CartInteractorProtocol {
    
    weak var presenter: CartPresenterProtocol?
    
    var cart: [Cart]?
    
    func getCartData() {
        presenter?.interactorUpdateData(cart: cart ?? [])
    }
    
}
