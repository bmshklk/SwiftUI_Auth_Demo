//
//  AuthStartView.swift
//  MainTarget
//
//  Created by o.sander on 24.06.2023.
//  
//

import SwiftUI
import TTProgressHUD

struct AuthStartView: View {

    @ObservedObject var vmodel: AuthStartViewModel

    var body: some View {
        ZStack {
            Group {
                switch vmodel.startScreen {
                case .signIn: SigninView(vmodel: vmodel.signInVM)
                case .signUp: SignupView(vmodel: vmodel.signUpVM)
                }
            }
            .transition(.opacity)
            TTProgressHUD($vmodel.showLoading,
                          config: TTProgressHUDConfig())
        }
        .alert("Error", isPresented: $vmodel.isDisplayingError, actions: {
            Button("Close", role: .cancel) { }
        }, message: {
            Text(vmodel.lastErrorMessage?.localizedDescription ?? "Something went wrong")
        })
    }
}

struct AuthStartView_Previews: PreviewProvider {
    static var previews: some View {
        AuthStartView(vmodel: AuthStartViewModel(authService: StubAuthService()))
    }
}
