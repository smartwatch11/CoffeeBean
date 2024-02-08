
import Foundation


protocol MenuInteractorProtocol: AnyObject {
    var presenter: MenuPresenterProtocol? {get set}
    var id: Int? {get set}
    func getItemsData()
}

final class MenuInteractor: MenuInteractorProtocol {
    
    weak var presenter: MenuPresenterProtocol?
    
    var id: Int?
    
    private let networkManager: MenuNetworkManagerProtocol
    
    init(networkManager: MenuNetworkManagerProtocol = MenuNetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getItemsData() {
        networkManager.getMenuItems(id: self.id ?? 0) { [weak self] locations in
            self?.presenter?.interactorWithData(result: .success(locations))
        }
    }
    
}
