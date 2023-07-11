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

    enum StoryResult {
        case authorized
        case unauthorized
    }

    typealias StoryBlock = (_ result: StoryResult) -> ()
}

class AuthRouter: BaseRouter {

    private let assembly: AuthAssembly
    private var storyCompletion: AuthRouter.StoryBlock?
    private var set = Set<AnyCancellable>()
    private var anchorNVC: UINavigationController?

    init(assembly: AuthAssembly) {
        self.assembly = assembly
    }

    func showAuthStory(start: AuthRouter.EntryPoint,
                       in nvc: UINavigationController,
                       animated: Bool,
                       completionBlock: @escaping AuthRouter.StoryBlock) {

        self.storyCompletion = completionBlock
        self.anchorNVC = nvc

        let vc = assembly.assembleAuthStartScreen()
        let authVM = vc.rootView.vmodel
        authVM.startScreen = start == .signup ? .signUp : .signIn
        authVM.actionsSubject
            .sink(receiveValue: { [weak self] action in
                switch action {
                case .forgotPassword: self?.showForgotPassword()
                }
            })
            .store(in: &set)

        nvc.setViewControllers([vc], animated: animated)
    }

    func hideAuthStory(animated: Bool, completion: VoidBlock?) {
        hide(animated: animated, completion: completion)
    }
}

private extension AuthRouter {
    func showForgotPassword() {
        guard let nvc = anchorNVC else { return }
        let nvcBackup = NavigationBarBackup(
            shouldRestoreToHidden: nvc.isNavigationBarHidden,
            appearance: nvc.navigationBar.standardAppearance,
            prefersLargeTitles: nvc.navigationBar.prefersLargeTitles)

        let actions = PassthroughSubject<Void, Never>()
        actions.sink(receiveValue: { [weak nvc] _ in
            guard let nvc else { return }
            nvc.popViewController(animated: true)
            nvc.apply(backup: nvcBackup)
        })
        .store(in: &set)

        let forgotPassVC = assembly.assembleForgotPassword(actionsSubject: actions)
        anchorNVC?.push(controller: forgotPassVC, animated: true)
    }
}
