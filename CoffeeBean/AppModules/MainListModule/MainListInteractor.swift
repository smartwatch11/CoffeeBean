
import Foundation

protocol MainListInteractorProtocol: AnyObject {
    var presenter: MainListPresenterProtocol? {get set}
    func getLocationsData()
    func quit()
}

final class MainListInteractor: MainListInteractorProtocol {
    
    weak var presenter: MainListPresenterProtocol?
    
    private let networkManager: MainListNetworkManagerProtocol
    
    init(networkManager: MainListNetworkManagerProtocol = MainListNetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getLocationsData() {
        networkManager.getLocations { [weak self] locations in
            if locations.isEmpty {
                self?.getLocationsData()
            } else {
                self?.presenter?.interactorWithData(result: .success(locations))
            }
        }
    }
    
    func quit() {
        do{
            let data = try KeychainManager.logout()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
