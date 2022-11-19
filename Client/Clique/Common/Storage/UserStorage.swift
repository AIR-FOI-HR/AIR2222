import UIKit

private enum DefaultValues: String {
    
   case email = "email"
    case token = "token"
    
}

final class UserStorage {

static var email: String {
    set {
        _set(value: newValue, key: .email)
    } get {
        return _get(valueForKay: .email) as? String ?? ""
    }
}
    
    static var token: String{
        set {
            _set(value: newValue, key: .token)
        } get {
            return _get(valueForKay: .token) as? String ?? ""
        }
    }


private static func _set(value: String, key: DefaultValues) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
}

private static func _get(valueForKay key: DefaultValues) -> Any? {
    return UserDefaults.standard.value(forKey: key.rawValue)
}

}
