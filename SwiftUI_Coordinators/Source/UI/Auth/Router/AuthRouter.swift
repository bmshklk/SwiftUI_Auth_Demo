//
//  AuthRouter.swift
//  MainTarget
//
//  Created by o.sander on 09.06.2023.
//  
//

import SwiftUI
import Combine

extension AuthRouter {
    enum EntryPoint {
        case signin
        case signup
    }

    enum Destination: Hashable, Identifiable {
        case forgotPassword
        var id: String { String(describing: self) }
    }
}

class AuthRouter: Router<AuthRouter.Destination> {

    let entryPoint: EntryPoint
    init(entry: EntryPoint) {
        self.entryPoint = entry
    }

    func loginView(start: AuthStartViewModel.StartView) -> AuthStartView {
        let vmodel = AuthStartViewModel()
        vmodel.startScreen = start
        vmodel.forgotPasswordAction = { [weak self] in
            self?.navigate(to: .forgotPassword)
        }
        return AuthStartView(vmodel: vmodel)
    }

    func forgotPasswordView() -> ForgotPasswordView {
        let vmodel = ForgotPasswordViewModel()
        vmodel.backAction = { [weak self] in
            self?.dismiss()
        }
        return ForgotPasswordView(vmodel: vmodel)
    }
}

struct AuthRouterView: View {

    @StateObject private var router: AuthRouter
    init(router: AuthRouter) {
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        NavigationStack(path: router.path) {
            Group {
                switch router.entryPoint {
                case .signin: router.loginView(start: .signIn)
                case .signup: router.loginView(start: .signUp)
                }
            }
            .navigationDestination(for: AuthRouter.Destination.self) { destination in
                switch destination {
                case .forgotPassword: router.forgotPasswordView()
                }
            }
        }
    }
}
