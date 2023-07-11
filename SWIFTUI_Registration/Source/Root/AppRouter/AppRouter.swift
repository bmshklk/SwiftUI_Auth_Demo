//
//  AppRouter.swift
//  MainTarget
//
//  Created by o.sander on 08.06.2023.
//
    
import SwiftUI
import Combine

protocol AppRoutingProtocol {

    func showInitialUI(from window: UIWindow)
}

class AppRouter: AppRoutingProtocol {

    private var appWindow: UIWindow!
    private var rootNavigationController: UINavigationController!
    private var authRouter: AuthRouter?
    private var onboardingRouter: OnboardingRouter?
    private var homeRouter: HomeRouter?
    private let assembly: AppAssemblyProtocol
    private var set = Set<AnyCancellable>()
    private let onboardingKey = "appRouter.onboarding.appearance.key"
    private(set) var shouldShowOnboarding: Bool {
        get { UserDefaults.standard.value(forKey: onboardingKey) as? Bool ?? true }
        set { UserDefaults.standard.setValue(newValue, forKey: onboardingKey) }
    }

    private var auth: AuthServiceProtocol {
        assembly.services.authService()
    }

    init(with assembly: AppAssemblyProtocol) {
        self.assembly = assembly
    }

    // MARK: -
    // MARK: Public
    func showInitialUI(from window: UIWindow) {

        self.appWindow = window
        let navVC = UINavigationController()
        navVC.isNavigationBarHidden = true
        window.rootViewController = navVC
        window.makeKeyAndVisible()

        self.rootNavigationController = navVC
        showOnboardingIfNeeded(from: navVC) { [unowned self] result in
            showMainUI(authEntryPoint: result.authEntryPoint)
        }
    }
}

extension AppRouter {
    func showMainUI(authEntryPoint: AuthRouter.EntryPoint = .signup) {
        auth
            .userSession
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] value in
                guard let self else { return }
                if value == nil {
                    self.showAuthFlow(from: self.rootNavigationController, entryPoint: authEntryPoint)
                    self.homeRouter = nil
                } else {
                    self.showHomeFlow(from: self.rootNavigationController)
                    self.authRouter = nil
                }
            }
            .store(in: &set)
    }

    func showHomeFlow(from controller: UINavigationController, animated: Bool = false) {
        let hRouter = assembly.assembleHomeRouter()
        hRouter.showHomeStory(in: controller, animated: animated)
        self.homeRouter = hRouter
    }

    func showOnboardingIfNeeded(from controller: UIViewController, completion: @escaping OnboardingRouter.StoryCompletion) {
        guard shouldShowOnboarding else {
            completion(.signUp)
            return
        }

        onboardingRouter = assembly.assembleOnboardingRouter()
        onboardingRouter?.showOnboarding(from: controller, completion: { [weak self] result in
            guard let self else { return }
            self.shouldShowOnboarding = false
            self.onboardingRouter?.hideStory(animated: false)
            self.onboardingRouter = nil
            completion(result)
        })
    }

    func showAuthFlow(from controller: UIViewController, entryPoint: AuthRouter.EntryPoint = .signup) {
        let authRouter = assembly.assembleAuthRouter()
        authRouter.showAuthStory(
            start: entryPoint,
            in: rootNavigationController,
            animated: true,
            completionBlock: { [weak self] _ in
                self?.authRouter?.hideAuthStory(animated: false, completion: nil)
                self?.authRouter = nil
            })
        self.authRouter = authRouter
    }
}

private extension OnboardingRouter.StoryResult {
    var authEntryPoint: AuthRouter.EntryPoint {
        switch self {
        case .signUp: return .signup
        case .login:  return .signin
        }
    }
}
