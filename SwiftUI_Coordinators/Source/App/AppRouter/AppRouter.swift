//
//  AppRouter.swift
//  MainTarget
//
//  Created by o.sander on 08.06.2023.
//
    
import SwiftUI
import Combine
import Factory

private extension OnboardingRouter.StoryResult {
    var authEntryPoint: AuthRouter.EntryPoint {
        switch self {
        case .signUp: return .signup
        case .login:  return .signin
        }
    }
}

class AppRouter: ObservableObject {

    enum Screen: Hashable, Equatable {
        case idle
        case onboarding
        case auth(AuthRouter.EntryPoint)
        case home
    }

    @Injected(\.authService) var authService
    @Published var screen: AppRouter.Screen = .idle

    private var onboardingRouter: OnboardingRouter?
    private var set = Set<AnyCancellable>()
    private let onboardingKey = "appRouter.onboarding.appearance.key"
    private(set) var shouldShowOnboarding: Bool {
        get { UserDefaults.standard.value(forKey: onboardingKey) as? Bool ?? true }
        set { UserDefaults.standard.setValue(newValue, forKey: onboardingKey) }
    }

    init() {
        setupBindings()
    }

    func onboardingRouterView() -> OnboardingRouterView {
        OnboardingRouterView { [weak self] result in
            guard let self else { return }
            switch result {
            case .login: self.screen = .auth(.signin)
            case .signUp: self.screen = .auth(.signup)
            }
            self.shouldShowOnboarding = false
        }
    }

    func authRouterView(entry: AuthRouter.EntryPoint) -> AuthRouterView {
        let router = AuthRouter(entry: entry)
        return AuthRouterView(router: router)
    }

    func homeRouterView() -> HomeRouterView {
        HomeRouterView(router: HomeRouter())
    }

    func setupBindings() {
        authService
            .userSession
            .removeDuplicates()
            .sink { [weak self] value in
                guard let self else { return }
                if value == nil {
                    self.screen = shouldShowOnboarding ? .onboarding : .auth(.signup)
                } else {
                    self.screen = .home
                }
            }
            .store(in: &set)
    }

    @ViewBuilder
    func idleView() -> some View {
        Image("splash_screen")
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

struct AppRouterView: View {
    @StateObject private var router: AppRouter = AppRouter()

    var body: some View {
        switch router.screen {
        case .idle:       router.idleView()
        case .onboarding: router.onboardingRouterView()
        case .auth(let entry):
            switch entry {
            case .signin: router.authRouterView(entry: .signin)
            case .signup: router.authRouterView(entry: .signup)
            }
        case .home:
            router.homeRouterView()
        }
    }
}
