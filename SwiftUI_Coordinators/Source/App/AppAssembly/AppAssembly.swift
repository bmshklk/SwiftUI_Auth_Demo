//
//  AppAssembly.swift
//  MainTarget
//
//  Created by o.sander on 08.06.2023.
//  
//

import Foundation
import Factory

extension Container {
    var authService: Factory<AuthServiceProtocol> {
        .init(self) { AuthService() }
        .onPreview { _ in
            StubAuthService()
        }
        .singleton
    }
}
