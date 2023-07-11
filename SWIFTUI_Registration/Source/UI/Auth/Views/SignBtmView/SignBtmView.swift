//
//  SignBtmView.swift
//  MainTarget
//
//  Created by o.sander on 15.06.2023.
//  
//

import SwiftUI
import Combine

enum AuthSocial: String, Hashable {
    case facebook
    case google
    case apple
}

extension SignBtmView.ViewModel {
    typealias ActionBlock = (_ action: Action) -> Void
    enum Action: Hashable {
        case enter
        case social(AuthSocial)
        case changeAuth
    }
}

extension SignBtmView {

    class ViewModel {
        let actions: PassthroughSubject<Action, Never> = .init()
        let enterTitle: String
        let socials: [AuthSocial]
        let loginOptionTitle: String
        let loginOptionButtonTitle: String

        init(enterTitle: String,
             socials: [AuthSocial],
             loginOptionTitle: String,
             loginOptionButtonTitle: String) {
            self.enterTitle = enterTitle
            self.socials = socials
            self.loginOptionTitle = loginOptionTitle
            self.loginOptionButtonTitle = loginOptionButtonTitle
        }
    }
}

struct SignBtmView: View {

    let vmodel: ViewModel

    var body: some View {
        VStack(spacing: 0) {
            Button(action: enterAction, label: {
                Text(vmodel.enterTitle)
            })
            .buttonStyle(.next)
            Spacer().frame(height: 23)
            Text("**Connect with**")
                .font(.appFootnote)
                .foregroundColor(Colors.rose1)
                .padding(.bottom, 7)
            HStack(spacing: 15) {
                ForEach(vmodel.socials, id: \.self) { item in
                    socialButton(social: item)
                }
            }
            .padding(.bottom, 24)
            Text(vmodel.loginOptionTitle)
                .font(.appCaption)
                .foregroundColor(Colors.primary)
            Button(action: changeAuthFormAction, label: {
                Text(vmodel.loginOptionButtonTitle)
                    .font(.appCaption)
                    .bold()
                    .foregroundColor(Colors.rose1)
                    .frame(minHeight: 44.0)
            })
        }
    }

    func socialButton(social: AuthSocial) -> some View {
        Button.init(action: {
            socialAction(social: social)
        }) {
            Image(social.imgName)
                .resizable()
                .frame(width: 44, height: 44)
        }
    }

    func enterAction() {
        vmodel.actions.send(.enter)
    }

    func socialAction(social: AuthSocial) {
        vmodel.actions.send(.social(social))
    }

    func changeAuthFormAction() {
        vmodel.actions.send(.changeAuth)
    }
}

private extension AuthSocial {
    var imgName: String {
        switch self {
        case .facebook: return "icon_social_facebook"
        case .google:   return "icon_social_google"
        case .apple:    return "icon_social_apple"
        }
    }
}

extension SignBtmView.ViewModel {
    static var preview: SignBtmView.ViewModel {
        SignBtmView.ViewModel(
            enterTitle: "Create account",
            socials: [.google, .apple],
            loginOptionTitle: "Already have an account?",
            loginOptionButtonTitle: "Login")
    }
}

struct SignBtmView_Previews: PreviewProvider {
    static let vmodel = SignBtmView.ViewModel.preview

    static var previews: some View {
        SignBtmView(vmodel: vmodel)
    }
}
