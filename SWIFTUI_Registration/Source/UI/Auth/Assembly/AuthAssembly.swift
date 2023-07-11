//
//  AuthAssembly.swift
//  MainTarget
//
//  Created by o.sander on 11.06.2023.
//  
//

import UIKit
import SwiftUI
import Combine

class AuthAssembly {

    let appAssembly: AppAssemblyProtocol

    // MARK: -
    // MARK: Init and Deinit
    init(with appAssembly: AppAssemblyProtocol) {
        self.appAssembly = appAssembly
    }
}

extension AuthAssembly {
    func assembleAuthStartScreen() -> UIHostingController<AuthStartView> {
        let authService = appAssembly.services.authService()
        let vmodel = AuthStartViewModel(authService: authService)
        return UIHostingController<AuthStartView>(rootView: AuthStartView(vmodel: vmodel))
    }

    func assembleForgotPassword(actionsSubject: PassthroughSubject<Void, Never>) -> UIHostingController<ForgotPasswordView> {
        let authService = appAssembly.services.authService()
        let vc = UIHostingController<ForgotPasswordView>(
            rootView: ForgotPasswordView(authService: authService,
                                         backActionSubject: actionsSubject)
        )
        return vc
    }
}
