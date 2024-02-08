import Foundation
import Alamofire

protocol MainListNetworkManagerProtocol {
    func getLocations(complition: @escaping ([LocationModel])->())
}

class MainListNetworkManager: MainListNetworkManagerProtocol {
    
    private let networkManager: LoginNetworkManagerProtocol
    
    init(networkManager: LoginNetworkManagerProtocol = LoginNetworkManager()) {
        self.networkManager = networkManager
    }
    
    func updateToken(login: String) {
        var password = ""
        do {
            let passData = try KeychainManager.getPassword(for: login)
            password = String(decoding: passData ?? Data(), as: UTF8.self)
        } catch {
            print("failed get token")
        }
        
        networkManager.userAuth(login: login, password: password) { data in
            if (data.token != nil) {
                do{
                    _ = try KeychainManager.updateToken(token: ((data.token?.data(using: .utf8) ?? String().data(using: .utf8))!), login: login)
                    let passData2 = try KeychainManager.getToken(for: login)
                    _ = String(decoding: passData2 ?? Data(), as: UTF8.self)
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("failed update token")
            }
        }
    }
    
    private var token: String = ""
    
    func getLocations(complition: @escaping ([LocationModel])->()) {
        do {
            let passData2 = try KeychainManager.getToken(for: UserDefaults.standard.object(forKey: "login") as? String ?? "")
            self.token = String(decoding: passData2 ?? Data(), as: UTF8.self)
        } catch {
            print(error.localizedDescription)
        }
        
        var request = URLRequest(url: URL(string: locationsUrl)!)
        
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        AF.request(request).response{ [weak self] resp in
            
            switch resp.result{
            case .success(let data):
                if let data = data {
                    do{
                        let jsonData = try JSONDecoder().decode([LocationModel].self, from: data)
                        complition(jsonData)
                    } catch {
                        if NSString(data: data, encoding: NSUTF8StringEncoding)! as String == "token is not valid or has expired" {
                            let email = UserDefaults.standard.object(forKey:"login") as! String
                            self?.updateToken(login: email)
                            let data: [LocationModel] = []
                            complition(data)
                        }
                        print(error.localizedDescription)
                    }
                } else {
                    print("empty response")
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
