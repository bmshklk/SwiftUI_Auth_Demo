//
//  SigninViewModel.swift
//  MainTarget
//
//  Created by o.sander on 19.06.2023.
//  
//

import Foundation
import Combine

extension SigninViewModel {
    enum Action {
        case changeAuthToSignup
        case login(SigninData)
        case signInWith(social: AuthSocial)
        case forgotPassword
    }
}

enum Action {
    case changeAuthToSignup
    case login(SigninData)
    case signInWith(social: AuthSocial)
    case forgotPassword
}

struct SigninData {
    var email = ""
    var password = ""
}

class SigninViewModel: ObservableObject {

    let actionsSubject: PassthroughSubject<SigninViewModel.Action, Never> = .init()
    let controlsVM: SignBtmView.ViewModel = .signin
    let fieldVMs: [MaterialTFVM] = SigninViewModel.textFieldsVMs
    @Published var inFocus: AuthField?
    private var set = Set<AnyCancellable>()
    
    init() {
        controlsVM.actions
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] action in
                guard let self else { return }
                self.handleBtmViewActions(action: action)
            })
            .store(in: &set)
    }

    func handleBtmViewActions(action: SignBtmView.ViewModel.Action) {
        switch action {
        case .changeAuth:
            actionsSubject.send(.changeAuthToSignup)
        case .enter:
            var data = SigninData()
            guard let email = fieldVMs.first(where: { $0.field == .email }) else { return }
            data.email = email.text
            guard let password = fieldVMs.first(where: { $0.field == .password }) else { return }
            data.password = password.text
            actionsSubject.send(.login(data))
        case .social(let social):
            actionsSubject.send(.signInWith(social: social))
        }
    }
}

extension SignBtmView.ViewModel {
    static var signin: SignBtmView.ViewModel {
        SignBtmView.ViewModel(
            enterTitle: "Let’s Combat!",
            socials: [.apple, .google],
            loginOptionTitle: "Don’t have an account?",
            loginOptionButtonTitle: "Create Account")
    }
}

extension SigninViewModel {
    static var textFieldsVMs: [MaterialTFVM] {

        let email = MaterialTFVM(
            id: AuthField.email.rawValue,
            style: .registration,
            placeholer: "Email",
            textContent: .emailAddress)

        let password = MaterialTFVM(
            id: AuthField.password.rawValue,
            style: .registration,
            placeholer: "Password",
            textContent: .password,
            isSecure: true)
        return [email, password]
    }
}

extension MaterialTFVM.Style {
    static var registration: MaterialTFVM.Style {
        MaterialTFVM.Style(textColor: Colors.primary,
                           activeTintColor: Colors.rose1,
                           errorTintColor: .red,
                           normalTintColor: Colors.rose2,
                           backgroundColor: .clear,
                           placeholderColor: Colors.primary,
                           hintColor: .gray)
    }
}
