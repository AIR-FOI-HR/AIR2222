import UIKit
import KeychainAccess


enum UserStorageValues: String {
    case token
}

let keychain = Keychain(service: "token")

class UserStorage {
    
    static var token: String? {
        set {
            setKey(value: newValue, key: .token)
        } get {
            return _get(key: .token) as? String
        }
    }
    
    private static func _get(key: UserStorageValues) -> Any? {
        return  try? keychain.get(key.rawValue)
    }

    private static func setKey(value: String!, key: UserStorageValues) {
         try? keychain.set(value, key: key.rawValue)
    }
    
    func removeKey(key: UserStorageValues) {
         do {
             try keychain.remove(key.rawValue)
         } catch let error {
             print("error: \(error)")
         }
     }
    
    
}
