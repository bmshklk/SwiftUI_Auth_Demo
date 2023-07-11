//
//  User.swift
//  MainTarget
//
//  Created by o.sander on 24.06.2023.
//  
//

import Foundation
import FirebaseAuth

struct User: Identifiable, Hashable, Equatable, Codable {
    let id: String
    let fullname: String?
    let nickname: String?
    let email: String?

    init(id: String, fullname: String? = nil, nickname: String? = nil, email: String? = nil) {
        self.id = id
        self.fullname = fullname
        self.nickname = nickname
        self.email = email
    }

    static func userFromFirebaseAuth(user: FirebaseAuth.User) -> User {
        User(id: user.uid, fullname: user.displayName, nickname: nil, email: user.email)
    }
}

extension User {
    static var mock: User {
        User(id: UUID().uuidString, fullname: "fullname", nickname: "mock user", email: "mock@user.com")
    }
}
