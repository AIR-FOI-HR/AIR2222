import UIKit
import KeychainAccess


private enum UserStorageValues: String {
    case token = "token"
}

let keychain = Keychain(service: "token")

final class UserStorage {
    
    static var token: String {
        set {
            setKey(value: newValue, key: .token)
        } get {
            return (_get(valueForKay: .token) ?? "")!
        }
    }


private static func _get(valueForKay key: UserStorageValues) -> String? {
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
}
