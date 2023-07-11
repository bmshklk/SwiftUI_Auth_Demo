//
//  MenuView.swift
//  MainTarget
//
//  Created by o.sander on 29.06.2023.
//  
//

import SwiftUI
import Combine
import Factory

extension MenuView {
    class ViewModel: ObservableObject {
        @Published var user: User?

        @Injected(\.authService) var authService

        private var set = Set<AnyCancellable>()
        var name: String? {
            if let fullname = user?.fullname {
                return "Fullname: \(fullname)"
            } else {
                return nil
            }
        }

        var nickname: String? {
            if let nickname = user?.nickname {
                return "Nickname: \(nickname)"
            } else {
                return nil
            }
        }

        var email: String? {
            if let email = user?.email {
                return "Email: \(email)"
            } else {
                return nil
            }
        }

        init() {
            authService
                .userSession
                .weakAssign(to: \.user, on: self)
                .store(in: &set)
        }

        func loguot() {
            authService.logout()
        }
    }
}

struct MenuView: View {
    @StateObject private var vmodel: ViewModel
    @Environment(\.dismiss) private var dismiss

    init() {
        _vmodel = StateObject(wrappedValue: ViewModel())
    }

    var body: some View {
        ZStack {
            Colors.menu.ignoresSafeArea()
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    if let name = vmodel.name {
                        Label(name, systemImage: "person.crop.circle")
                    }
                    if let nick = vmodel.nickname {
                        Label(nick, systemImage: "person.crop.circle")
                    }
                    if let email = vmodel.email {
                        Label(email, systemImage: "envelope.fill")
                    }
                }
                .foregroundColor(.primary)
                .font(.poppinsFixed(size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

                Spacer()
                Button {
                    dismiss()
                    vmodel.loguot()
                } label: {
                    Label("Logout", systemImage: "arrow.backward.square")
                        .frame(minHeight: 44.0)
                        .font(.appBody).bold()
                        .foregroundColor(Colors.rose1)
                }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
