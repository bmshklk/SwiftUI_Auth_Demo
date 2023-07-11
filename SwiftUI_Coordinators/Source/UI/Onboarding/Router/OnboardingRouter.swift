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
    enum Destination: Hashable, Identifiable {
        case onboarding1
        case onboarding2
        case onboarding3

        var id: String { String(describing: self) }
    }
}

class OnboardingRouter: Router<OnboardingRouter.Destination> {
    enum StoryResult {
        case signUp
        case login
    }

    typealias StoryCompletion = (_ result: StoryResult) -> Void

    private var set = Set<AnyCancellable>()
    private var storyCompletion: StoryCompletion?

    init(completion: @escaping StoryCompletion) {
        self.storyCompletion = completion
    }

    func onboardingView() -> OnboardingView {
        let actionsCallback = PassthroughSubject<OnboardingView.Actions, Never>()
        actionsCallback
            .sink(receiveValue: { [weak self] action in
                switch action {
                case .login:  self?.completeStory(with: .login)
                case .signup: self?.completeStory(with: .signUp)
                }
            })
            .store(in: &set)
        return OnboardingView(actions: actionsCallback)
    }
}

private extension OnboardingRouter {

    func completeStory(with result: StoryResult) {
        storyCompletion?(result)
        storyCompletion = nil
    }
}

struct OnboardingRouterView: View {

    @StateObject private var router: OnboardingRouter

    init(completion: @escaping OnboardingRouter.StoryCompletion) {
        _router = StateObject(wrappedValue: OnboardingRouter(completion: completion))
    }

    var body: some View {
        router.onboardingView()
    }
}
