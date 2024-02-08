
import Foundation

enum KeychainError: Error {
    case duplicateItem
    case unknown(status: OSStatus)
    case noPassword
}

final class KeychainManager {
    static func savePassword(password: Data, login: String) throws -> String {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: login,
            kSecValueData: password
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateItem
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status: status)
        }
        
        return "Saved"
    }
    
    static func getPassword(for login: String) throws -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: login,
            kSecReturnData: kCFBooleanTrue as Any
        ]
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status: status)
        }
        
        return result as? Data
    }
    
    static func saveToken(token: Data, login: String) throws -> String {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: login + "token",
            kSecValueData: token
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateItem
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status: status)
        }
        
        return "Saved"
    }
    
    static func updateToken(token: Data, login: String) throws -> String {
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: login + "token"
        ]
        
        let attributes: [CFString: Any] = [
            kSecValueData: token
        ]
        
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        guard status != errSecItemNotFound else {
            throw KeychainError.noPassword
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status: status)
        }
        print(status)
        
        return "Updated"
    }
    
    static func getToken(for login: String) throws -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: login + "token",
            kSecReturnData: kCFBooleanTrue as Any
        ]
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status: status)
        }
        
        return result as? Data
    }
    
    static func logout() throws -> String {
        let login = UserDefaults.standard.object(forKey: "login") as! String
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: login + "token"
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status != errSecItemNotFound else {
            throw KeychainError.noPassword
        }
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status: status)
        }
        print(status)
        
        let queryPas: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: login
        ]
        let statusPas = SecItemDelete(queryPas as CFDictionary)
        guard statusPas != errSecItemNotFound else {
            throw KeychainError.noPassword
        }
        guard statusPas == errSecSuccess else {
            throw KeychainError.unknown(status: statusPas)
        }
        print(statusPas)
        UserDefaults.standard.removeObject(forKey: "login")
        
        return "Deleted"
    }
    
}
