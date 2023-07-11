//
//  AuthServiceProtocol.swift
//  MainTarget
//
//  Created by o.sander on 26.06.2023.
//  
//

import Foundation
import Combine

protocol AuthServiceProtocol {

    var userSession: AnyPublisher<User?, Never> { get }
    func createUserWithEmail(_ signupData: SignupData) async throws
    func login(email: String, password: String) async throws
    func logout()

    // Socials
    func performGoogleAccountLink() async throws
    func performAppleAccountLink() async throws

    // Forgot password
    func resetPassword(email: String) async throws
}

final class StubAuthService: AuthServiceProtocol {

    var userSession = Just<User?>.init(nil).eraseToAnyPublisher()
    func createUserWithEmail(_ signupData: SignupData) async throws {}
    func login(email: String, password: String) async throws {}
    func logout() {}

    func performGoogleAccountLink() async throws {}
    func performAppleAccountLink() async throws {}
    func resetPassword(email: String) async throws {}
}
