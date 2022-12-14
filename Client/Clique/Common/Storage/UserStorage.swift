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
            return getKey(key: .token) as? String
        }
    }
    
    private static func getKey(key: UserStorageValues) -> Any? {
        return try? keychain.get(key.rawValue)
    }

    private static func setKey(value: String?, key: UserStorageValues) {
        guard let value = value else {
            try? keychain.remove(key.rawValue)
            return
        }
        do {
            try keychain.set(value, key: key.rawValue)
        } catch let error {
            print("error \(error)")
        }
    }
}
