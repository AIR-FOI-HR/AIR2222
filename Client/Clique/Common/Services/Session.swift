//
//  Session.swift
//  Clique
//
//  Created by Infinum on 22.12.2022..
//

import Foundation
import JWTDecode

final class Session {
    func getUserId() -> Int {
        var id = 0
        do {
            let jwt = try decode (jwt: UserStorage.token!)
            if let userId = jwt["UserId"].string {
                id = Int(userId) ?? 0
            }
        } catch {
            return 0
        }
        return id
    }
}
