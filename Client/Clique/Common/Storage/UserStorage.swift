import UIKit
import Foundation

private enum DefaultValues: String {
   case email = "email"
}

final class UserStorage {

static var email: String {
    set{
        _set(value: newValue, key: .email)
    } get {
        return _get(valueForKay: .email) as? String ?? ""
    }
}


private static func _set(value: String, key: DefaultValues) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
}

private static func _get(valueForKay key: DefaultValues)-> Any? {
    return UserDefaults.standard.value(forKey: key.rawValue)
}

}
