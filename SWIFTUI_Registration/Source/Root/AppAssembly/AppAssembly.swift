//
//  AppAssembly.swift
//  MainTarget
//
//  Created by o.sander on 08.06.2023.
//  
//

import Foundation

protocol AppAssemblyProtocol {

    var config: AppConfig { get }
    var services: AppAssembly.Services { get }
    func assembleAppRouter() -> AppRoutingProtocol
    func assembleAuthRouter() -> AuthRouter
    func assembleOnboardingRouter() -> OnboardingRouter
    func assembleHomeRouter() -> HomeRouter
}

class AppAssembly {

    let config: AppConfig
    let services: Services

    init(with config: AppConfig, services: Services = Services()) {
        self.config = config
        self.services = services
    }
}

extension AppAssembly: AppAssemblyProtocol {

    func assembleAppRouter() -> AppRoutingProtocol { AppRouter(with: self) }
    func assembleAuthRouter() -> AuthRouter {
        let assembly = AuthAssembly(with: self)
        return AuthRouter(assembly: assembly)
    }

    func assembleOnboardingRouter() -> OnboardingRouter {
        OnboardingRouter()
    }

    func assembleHomeRouter() -> HomeRouter {
        HomeRouter(assembly: HomeAssembly(appAssembly: self))
    }
}
