import UIKit

private enum UserStorageValues: String {
   case email = "email"
    case token = "token"
}

final class UserStorage {

static var email: String? {
    set {
        _set(value: newValue, key: .email)
    } get {
        return _get(valueForKay: .email) as? String
    }
}
    
    static var token: String? {
        set {
            _set(value: newValue, key: .token)
        } get {
            return _get(valueForKay: .token) as? String
        }
    }


private static func _set(value: Any?, key: UserStorageValues) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
}

private static func _get(valueForKay key: UserStorageValues) -> Any? {
    return UserDefaults.standard.value(forKey: key.rawValue)
}

}
