//
//  AuthService.swift
//  MainTarget
//
//  Created by o.sander on 23.06.2023.
//  

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import Combine
import GoogleSignIn
import AuthenticationServices
import Firebase

extension String: Error {}

class AuthService: NSObject, AuthServiceProtocol {

    var userSession: AnyPublisher<User?, Never> {
        firebaseAuthUserSession
            .map({ fbuser -> User? in
                guard let fbuser else { return nil }
                return User.userFromFirebaseAuth(user: fbuser)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private var firebaseAuthUserSession = CurrentValueSubject<FirebaseAuth.User?, Never>.init(nil)
    private var handler: AuthStateDidChangeListenerHandle?
    // For Sign in with Apple
    private var currentNonce: String?
    private var appleSigninContinuation: CheckedContinuation<AppleCredentials, Error>?

    deinit {
        guard let handler else { return }
        FirebaseAuth.Auth.auth().removeStateDidChangeListener(handler)
    }

    override init() {
        super.init()
        handler = FirebaseAuth.Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self else { return }
            self.firebaseAuthUserSession.value = user
            Log.log(consoleMessage: "Firebase User Listener | User: \(String(describing: user))", level: .debug)
        }
    }

    @MainActor
    func createUserWithEmail(_ signupData: SignupData) async throws {
        try await FirebaseAuth.Auth.auth().createUser(
            withEmail: signupData.email, password: signupData.password
        )
    }

    func login(email: String, password: String) async throws {
        try await FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password)
    }

    func logout() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {
            Log.log(consoleMessage: "Logout error: \(error.localizedDescription)", level: .error)
        }
        firebaseAuthUserSession.value = nil
    }

    func uploadUserData(userID: String, username: String, email: String) async throws {

    }
}

// MARK: -
// MARK: Socials Signin
extension AuthService {

    @MainActor
    func performGoogleAccountLink() async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let rootViewController = rootVC() else { return }
        let userAuth = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        let user = userAuth.user
        guard let idToken = user.idToken else { throw "Authentication data is missing" }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                       accessToken: user.accessToken.tokenString)
        try await FirebaseAuth.Auth.auth().signIn(with: credential)
    }

    func performAppleAccountLink() async throws {
        let creds = try await performAppleAuthRequest()
        let result = try await FirebaseAuth.Auth.auth().signIn(with: creds.firebase)
        await updateDisplayName(for: result.user, with: creds.apple)
    }
}

// MARK: -
// MARK: ASAuthorizationControllerDelegate
extension AuthService: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential
        else {
            appleSigninContinuation?.resume(throwing: "Unable to retrieve AppleIDCredential")
            return
        }

        guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }

        guard let appleIDToken = appleIDCredential.identityToken else {
            appleSigninContinuation?.resume(throwing: "Unable to fetch identity token")
            return
        }

        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            appleSigninContinuation?.resume(throwing: "Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }

        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        let resultCreds = AppleCredentials(firebase: credential, apple: appleIDCredential)
        appleSigninContinuation?.resume(returning: resultCreds)
    }

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        appleSigninContinuation?.resume(throwing: error)
    }
}

// MARK: -
// MARK: ASAuthorizationControllerPresentationContextProviding
extension AuthService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let window: UIWindow
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let wndw = scene.windows.first {
            window = wndw
        } else if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let wndw = windowScene.windows.first {
            window = wndw
        } else {
            assertionFailure("unable to find window during apple sign in")
            window = ASPresentationAnchor()
        }

        return window
    }
}

// MARK: -
// MARK: Reset Password
extension AuthService {
    func resetPassword(email: String) async throws {
        try await FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email)
    }
}

// MARK: -
// MARK: Private
private extension AuthService {

    func performAppleAuthRequest() async throws -> AppleCredentials {
        let nonce = try Crypton.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = Crypton.sha256(nonce)

        return try await withCheckedThrowingContinuation { continuation in
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
            self.appleSigninContinuation = continuation
        }
    }

    func updateDisplayName(for user: FirebaseAuth.User,
                           with appleIDCredential: ASAuthorizationAppleIDCredential,
                           force: Bool = false) async {

        // if current user is non-empty, don't overwrite it
        guard (FirebaseAuth.Auth.auth().currentUser?.displayName ?? "").isEmpty else {
            Log.log(consoleMessage: "No need to update usser session dispalay name", level: .debug)
            return
        }

        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = appleIDCredential.displayName()
        do {
            try await changeRequest.commitChanges()
            Log.log(consoleMessage: "UPDATE DISPLAY name", level: .debug)
            firebaseAuthUserSession.value = FirebaseAuth.Auth.auth().currentUser
        } catch {
            print("Unable to update the user's displayname: \(error.localizedDescription)")
        }
    }

    func rootVC() -> UIViewController? {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
            return rootViewController
        } else {
            return nil
        }
    }

    /// Sign in with apple specific
    struct AppleCredentials {
        let firebase: OAuthCredential
        let apple: ASAuthorizationAppleIDCredential
    }
}

extension ASAuthorizationAppleIDCredential {
    func displayName() -> String {
        [self.fullName?.givenName, self.fullName?.familyName]
            .compactMap( {$0})
            .joined(separator: " ")
    }
}
