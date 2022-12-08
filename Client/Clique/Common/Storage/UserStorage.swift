import UIKit
import KeychainAccess


enum UserStorageValues: String {
    case token = "token"
}

let keychain = Keychain(service: "token")

class UserStorage {
    
    static var token: String? {
        set {
            setKey(value: newValue, key: .token)
        } get {
            return getKey(key: .token) as? String
        }
    }
    
    private static func getKey(key: UserStorageValues) -> Any? {
        return try? keychain.get(key.rawValue)
    }

    private static func setKey(value: String?, key: UserStorageValues) {
        do {
            if let newValue = value {
                try keychain.set(newValue, key: key.rawValue)
            }
        } catch let error {
            print("error: \(error)")
        }
    }
}
