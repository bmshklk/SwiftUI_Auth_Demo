//
//  SignupViewModel.swift
//  MainTarget
//
//  Created by o.sander on 19.06.2023.
//  
//

import SwiftUI
import Combine

enum AuthField: String, CaseIterable {
    case fullname
    case nickname
    case email
    case password
    case confirmPassword
}

struct SignupData {
    let id = UUID()
    var fullName = ""
    var nickName = ""
    var phone = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
}

extension SignupViewModel {
    enum Action {
        case next(SignupData)
        case signUpWith(social: AuthSocial)
        case changeAuthToLogin
    }
}

class SignupViewModel: ObservableObject {

    let actionsSubject: PassthroughSubject<Action, Never> = .init()
    let controlsVM: SignBtmView.ViewModel = .signup
    let fieldVMs: [MaterialTFVM] = SignupViewModel.fieldsVMs
    @Published var inFocus: AuthField?
    private var set = Set<AnyCancellable>()

    init() {
        for fieldVM in fieldVMs {
            fieldVM.$text
                .dropFirst()
                .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
                .sink { [weak self, weak fieldVM] newText in
                    guard let self, let fieldVM else { return }
                    self.isValid(fieldVM: fieldVM, text: newText)
                }
                .store(in: &set)
        }

        controlsVM.actions
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] action in
                guard let self else { return }
                self.handleBtmViewActions(action: action)
            })
            .store(in: &set)
    }

    func toggleFocus() {
        guard let inFocus else { return }
        switch inFocus {
        case .fullname:        self.inFocus = .nickname
        case .nickname:        self.inFocus = .email
        case .email:           self.inFocus = .password
        case .password:        self.inFocus = .confirmPassword
        case .confirmPassword: self.inFocus = nil
        }
    }

    func generateUserData() -> SignupData {
        var data = SignupData()
        for vm in fieldVMs {
            switch vm.field {
            case .fullname:        data.fullName = vm.text
            case .nickname:        data.nickName = vm.text
            case .email:           data.email = vm.text
            case .password:        data.password = vm.text
            case .confirmPassword: data.confirmPassword = vm.text
            }
        }

        return data
    }

    func handleBtmViewActions(action: SignBtmView.ViewModel.Action) {
        switch action {
        case .changeAuth:
            actionsSubject.send(.changeAuthToLogin)
        case .enter:
            var allFieldsAreValid = true
            for vm in fieldVMs {
                let result = isValid(fieldVM: vm, text: vm.text)
                // in case we have invalid field somewhere in the middle
                // we want to remember that whole validation is failed
                // but continue loop to highlight text fields with errors
                if allFieldsAreValid {
                    allFieldsAreValid = result
                }
            }
            guard allFieldsAreValid else { return }
            let data = generateUserData()
            actionsSubject.send(.next(data))
        case .social(let social):
            actionsSubject.send(.signUpWith(social: social))
        }
    }

    // MARK: Validation
    @discardableResult
    func isValid(fieldVM: MaterialTFVM, text: String) -> Bool {
        switch fieldVM.field {
        case .fullname, .nickname:
            guard Auth.Validator.isNonEmpty(text) else {
                fieldVM.error = "Text can not be empty!"
                return false
            }
            fieldVM.error = nil
        case .email:
            let errors = Auth.Validator.validate(email: text)
            guard errors.isEmpty else {
                fieldVM.error = errors[0].localizedDescription
                return false
            }
            fieldVM.error = nil
        case .password:
            let errors = Auth.Validator.validate(password: text)
            guard errors.isEmpty else {
                fieldVM.error = errors[0].errorDescription
                return false
            }
            fieldVM.error = nil
        case .confirmPassword:
            guard let passwordVM = fieldVMs.first(where: { $0.field == .password }),
                      passwordVM.text == fieldVM.text
            else {
                fieldVM.error = Auth.PasswordError.confirmMismatch.localizedDescription
                return false
            }
            fieldVM.error = nil
        }

        return true
    }
}

extension SignBtmView.ViewModel {
    static var signup: SignBtmView.ViewModel {
        SignBtmView.ViewModel(
            enterTitle: "Create Account",
            socials: [.apple, .google],
            loginOptionTitle: "Already have an account?",
            loginOptionButtonTitle: "Login")
    }
}

extension SignupViewModel {
    static var fieldsVMs: [MaterialTFVM] {
        AuthField.allCases.map { field -> MaterialTFVM in
            let placeholder: String
            let textContent: UITextContentType?
            switch field {
            case .fullname:
                placeholder = "Full Name"
                textContent = .name
            case .nickname:
                placeholder = "User Name"
                textContent = .nickname
            case .email:
                placeholder = "Email"
                textContent = .emailAddress
            case .password:
                placeholder = "Password"
                textContent = .password
            case .confirmPassword:
                placeholder = "Confirm Password"
                textContent = .password
            }

            return MaterialTFVM(
                id: field.rawValue,
                style: .registration,
                placeholer: placeholder,
                textContent: textContent,
                isSecure: [UITextContentType.password, .newPassword].contains(textContent))
        }
    }
}
