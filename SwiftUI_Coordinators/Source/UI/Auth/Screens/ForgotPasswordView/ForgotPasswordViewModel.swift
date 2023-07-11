//
//  ForgotPasswordViewModel.swift
//  MainTarget
//
//  Created by o.sander on 27.06.2023.
//  
//

import SwiftUI
import Combine
import Factory

class ForgotPasswordViewModel: ObservableObject {

    enum Popup {
        case nothing
        case error(Error)
        case success
    }

    var backAction: VoidBlock?

    @Published var showLoading: Bool = false
    @Published var popupState: Popup = .nothing {
        didSet {
            switch popupState {
            case .nothing:
                isDisplayingError = false
                isDisplayingSuccess = false
            case .error:
                isDisplayingError = true
                isDisplayingSuccess = false
            case .success:
                isDisplayingError = false
                isDisplayingSuccess = true
            }
        }
    }

    @Published var isDisplayingError = false
    @Published var isDisplayingSuccess = false
    let emailVM = MaterialTFVM(id: AuthField.email.rawValue,
                               style: .registration,
                               placeholer: "Email",
                               textContent: .emailAddress)
    var lastErrorMessage: String? {
        guard case .error(let error) = popupState else { return nil }
        return error.localizedDescription
    }

    @Injected(\.authService) var authService
    private var set = Set<AnyCancellable>()

    init() {
        emailVM.$text
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] newText in
                let errors = Auth.Validator.validate(email: newText)
                guard errors.isEmpty else {
                    self?.emailVM.error = errors[0].localizedDescription
                    return
                }
                self?.emailVM.error = nil
            }
            .store(in: &set)
    }

    func sendRestPassword() {
        guard isEmailValid() else { return }
        Task { @MainActor in
            showLoading = true
            do {
                try await authService.resetPassword(email: emailVM.text)
                popupState = .success
                // await 3 sec. to give users time to read success message
                try await Task.sleep(nanoseconds: 3_000_000_000)
                backAction?()
            } catch {
                popupState = .error(error)
            }
            showLoading = false
        }
    }
}

// MARK: -
// MARK: Private
private extension ForgotPasswordViewModel {
    func isEmailValid() -> Bool {
        let errors = Auth.Validator.validate(email: emailVM.text)
        guard errors.isEmpty else {
            emailVM.error = errors[0].localizedDescription
            return false
        }
        emailVM.error = nil
        return true
    }
}
