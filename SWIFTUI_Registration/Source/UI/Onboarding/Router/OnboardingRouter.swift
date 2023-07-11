//
//  OnboardingRouter.swift
//  MainTarget
//
//  Created by o.sander on 29.06.2023.
//  
//

import Combine
import SwiftUI

extension OnboardingRouter {

    enum StoryResult {
        case signUp
        case login
    }

    typealias StoryCompletion = (_ result: StoryResult) -> Void
}

class OnboardingRouter: BaseRouter {

    private var storyCompletion: StoryCompletion?
    private var set = Set<AnyCancellable>()

    func showOnboarding(from controller: UIViewController, animated: Bool = false, completion: @escaping StoryCompletion) {
        self.storyCompletion = completion

        let actionsCallback = PassthroughSubject<OnboardingView.Actions, Never>()
        actionsCallback
            .sink(receiveValue: { [weak self] action in
                switch action {
                case .login: self?.completeStory(with: .login)
                case .signup: self?.completeStory(with: .signUp)
                }
            })
            .store(in: &set)
        let vc = UIHostingController(rootView: OnboardingView(actions: actionsCallback))
        show(initialController: vc,
             transitionMethod: .push,
             from: controller,
             animated: animated)
    }

    func hideStory(animated: Bool) {
        hide(animated: animated)
    }
}

private extension OnboardingRouter {
    func completeStory(with result: StoryResult) {
        storyCompletion?(result)
        storyCompletion = nil
    }
}
