import Foundation
import Alamofire

protocol MenuNetworkManagerProtocol {
    func getMenuItems(id: Int, complition: @escaping ([MenuModel])->())
}

class MenuNetworkManager: MenuNetworkManagerProtocol {

    private var token: String = ""
    
    func getMenuItems(id: Int, complition: @escaping ([MenuModel])->()) {
        
        do {
            let passData2 = try KeychainManager.getToken(for: UserDefaults.standard.object(forKey: "login") as? String ?? "")
            self.token = String(decoding: passData2 ?? Data(), as: UTF8.self)
        } catch {
            print(error.localizedDescription)
        }

        let url = locationUrl + "\(id)/menu"

        var request = URLRequest(url: URL(string: url)!)

        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")

        AF.request(request).response{ resp in

            switch resp.result{
            case .success(let data):
                if let data = data {
                    do{
                        let jsonData = try JSONDecoder().decode([MenuModel].self, from: data)
                        complition(jsonData)
                    } catch {
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
