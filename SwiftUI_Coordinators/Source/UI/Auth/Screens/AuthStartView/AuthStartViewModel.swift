//
//  AuthStartViewModel.swift
//  MainTarget
//
//  Created by o.sander on 24.06.2023.
//  
//

import SwiftUI
import Combine
import Factory

extension AuthStartViewModel {
    enum StartView {
        case signUp
        case signIn
    }
}

class AuthStartViewModel: ObservableObject {

    var forgotPasswordAction: VoidBlock?

    @Published var startScreen: StartView = .signUp
    let signInVM: SigninViewModel
    let signUpVM: SignupViewModel
    @Injected(\.authService) var authService

    @MainActor @Published var showLoading: Bool = false
    @MainActor @Published var lastErrorMessage: Error? {
        didSet {
            if lastErrorMessage != nil { isDisplayingError = true }
        }
    }

    @MainActor @Published var isDisplayingError = false

    private var set = Set<AnyCancellable>()

    init(signInVM: SigninViewModel = .init(),
         signUpVM: SignupViewModel = .init()) {

        self.signInVM = signInVM
        self.signUpVM = signUpVM

        signInVM.actionsSubject
            .sink(receiveValue: { [weak self] action in
                guard let self else { return }
                switch action {
                case .changeAuthToSignup: withAnimation { self.startScreen = .signUp }
                case .forgotPassword: self.forgotPasswordAction?()
                case .login(let loginData):
                    self.performSignIn(with: loginData)
                case .signInWith(let social): self.handle(socials: social)
                }
            })
            .store(in: &set)

        signUpVM
            .actionsSubject
            .sink(receiveValue: { [weak self] action in
                guard let self else { return }
                switch action {
                case .changeAuthToLogin: withAnimation { self.startScreen = .signIn }
                case .signUpWith(let social): self.handle(socials: social)
                case .next(let signup):
                    self.performSignup(with: signup)
                }
            })
            .store(in: &set)
    }
}

private extension AuthStartViewModel {

    func performSignIn(with data: SigninData) {
        Task { @MainActor in

            showLoading = true
            do {
                try await authService.login(email: data.email, password: data.password)
            } catch {
                self.lastErrorMessage = error
            }
            showLoading = false
        }
    }

    func performSignup(with data: SignupData) {
        Task { @MainActor in
            showLoading = true
            do {
                try await authService.createUserWithEmail(data)
            } catch {
                self.lastErrorMessage = error
            }
            showLoading = false
        }
    }

    func handle(socials: AuthSocial) {
        switch socials {
        case .google: linkGoogleAccont()
        case .apple:  linkAppleAccont()
        default: return
        }
    }

    func linkGoogleAccont() {
        Task { @MainActor in
            showLoading = true
            do {
                try await authService.performGoogleAccountLink()
            } catch {
                self.lastErrorMessage = error
            }
            showLoading = false
        }
    }

    func linkAppleAccont() {
        Task { @MainActor in
            showLoading = true
            do {
                try await authService.performAppleAccountLink()
            } catch {
                self.lastErrorMessage = error
            }
            showLoading = false
        }
    }
}
