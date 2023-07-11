//
//  AppAssembly+Services.swift
//  MainTarget
//
//  Created by o.sander on 25.06.2023.
//  
//

import Foundation

/// dependency injection container
extension AppAssembly {
    class Services {
        private lazy var sharedAuthService: AuthService = { AuthService() }()

        func authService() -> AuthServiceProtocol { sharedAuthService }
    }
}
