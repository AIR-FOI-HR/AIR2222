import UIKit
import KeychainAccess


enum UserStorageValues: String {
    case token = "token"
}

let keychain = Keychain(service: "token")

class UserStorage {
    
    static var token: String {
        set {
            setKey(value: newValue, key: .token)
        } get {
            return (_get(key: .token) ?? "")!
        }
    }
    
    private static func _get(key: UserStorageValues) -> String? {
        return  try? keychain.get(key.rawValue)
    }

    private static func setKey(value: String, key: UserStorageValues) {
        do {
            try keychain.set(value, key: key.rawValue)
        }
        catch let error {
            print(error)
        }
    }
    
    func removeKey(key: UserStorageValues) {
         do {
             try keychain.remove(key.rawValue)
         } catch let error {
             print("error: \(error)")
         }
     }
    
    
}
