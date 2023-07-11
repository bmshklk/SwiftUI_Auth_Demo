//
//  ForgotPasswordView.swift
//  MainTarget
//
//  Created by o.sander on 27.06.2023.
//  
//

import SwiftUI
import Combine
import TTProgressHUD

struct ForgotPasswordView: View {

    @StateObject var vmodel: ForgotPasswordViewModel
    init(authService: AuthServiceProtocol,
         backActionSubject: PassthroughSubject<Void, Never>) {
        self._vmodel = StateObject(wrappedValue: ForgotPasswordViewModel(
            authService: authService,
            backSubject: backActionSubject)
        )
    }

    var body: some View {
        ZStack {
            Colors.backgoundColor.ignoresSafeArea()
            VStack {
                Image("illustration_reset_password")
                VStack(alignment: .leading, spacing: 12) {
                    Text("Forgot password?")
                        .bold()
                        .font(.title2)
                        .foregroundColor(Colors.rose1)

                    Text("Enter your email address below and we'll send you an email with instructions on how to change your password")
                        .font(.appCaption)
                        .foregroundColor(Colors.primary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
                .padding(.bottom, 40)
                MaterialTextField(vmodel: vmodel.emailVM)
                Button(action: {
                    vmodel.sendRestPassword()
                }, label: {
                    Text("Recover Password")
                })
                .buttonStyle(.next)
                .padding(.top, 46)
                Spacer()
            }
            .padding(.horizontal, 32)
            .padding(.top, 46)
            .alert("Error", isPresented: $vmodel.isDisplayingError, actions: {
                Button("OK", role: .cancel) {
                    vmodel.popupState = .nothing
                }
            }, message: {
                Text(vmodel.lastErrorMessage ?? "Something went wrong")
            })
            TTProgressHUD($vmodel.showLoading, config: TTProgressHUDConfig())
            if vmodel.isDisplayingSuccess {
                TTProgressHUD($vmodel.isDisplayingSuccess,
                              config: TTProgressHUDConfig(
                                type: .success, caption: "Instructions were sent to your email: \(vmodel.emailVM.text)"))
            }
        }
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    vmodel.backSubject.send()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Colors.rose1)
                        .font(.headline.weight(.bold))
                }
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(authService: StubAuthService(),
                           backActionSubject: .init())
    }
}

