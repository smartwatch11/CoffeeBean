import Foundation
import Alamofire

protocol RegNetworkManagerProtocol {
    func userReg(login: String, password: String, complition: @escaping (LoginRegResponseModel)->())
}

class RegNetworkManager: RegNetworkManagerProtocol {

    private var token: String = ""
    
    private func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func userReg(login: String, password: String, complition: @escaping (LoginRegResponseModel)->()) {
        
        let parametrs: [String: String] = ["login": login,"password": password]
        
        var request = URLRequest(url: URL(string: regUrl)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let pjson = json(from:parametrs as Any)
        let data = (pjson?.data(using: .utf8))! as Data

        request.httpBody = data
        AF.request(request).response{ resp in

            switch resp.result{
            case .success(let data):
                if let data = data {
                    do{
                        let jsonData = try JSONDecoder().decode(LoginRegResponseModel.self, from: data)
                        complition(jsonData)
                    } catch {
                        print(error.localizedDescription)
                        complition(LoginRegResponseModel(token: nil, tokenLifetime: 0))
                    }
                } else {
                    complition(LoginRegResponseModel(token: nil, tokenLifetime: 0))
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                complition(LoginRegResponseModel(token: nil, tokenLifetime: 0))
            }
        }
    }
}
