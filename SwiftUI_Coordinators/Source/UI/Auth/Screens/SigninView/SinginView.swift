//
//  SigninView.swift
//  MainTarget
//
//  Created by o.sander on 09.06.2023.
//  
//

import SwiftUI

struct SigninView: View {

    @ObservedObject var vmodel: SigninViewModel
    @FocusState private var inFocus: AuthField?

    var body: some View {

        ZStack {
            Colors.backgoundColor.ignoresSafeArea()
            scroll
        }
    }

    var scroll: some View {
        Group {
            if #available(iOS 16.4, *) {
                ScrollView { main }
                .scrollBounceBehavior(.basedOnSize)
            } else {
                ScrollView { main }
            }
        }
    }

    var main: some View {
        VStack(spacing: 0) {

            // image
            HStack {
                Image("illustration_signin")
                Spacer()
            }

            // Title & subtitle
            VStack(alignment: .leading, spacing: 12) {
                Text("Welcome Back!")
                    .font(.appTitle2)
                    .bold()
                    .foregroundColor(Colors.rose1)
                Text("Hi, Kindly login to continue battle")
                    .font(.appBody)
                    .foregroundColor(Colors.primary)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 40)
            .frame(maxWidth: .infinity, alignment: .leading)
            // stack of fields + forgot button
            VStack(spacing: 0) {
                ForEach(vmodel.fieldVMs) {
                    MaterialTextField(vmodel: $0)
                        .focused($inFocus, equals: $0.field)
                        .submitLabel($0.field == .confirmPassword ? .done : .next)
                }
                HStack {
                    Spacer()
                    Button {
                        vmodel.actionsSubject.send(.forgotPassword)
                    } label: {
                        Text("Forgot Password?")
                            .font(.appFootnote)
                            .foregroundColor(Colors.primary)
                            .frame(minHeight: 44.0)
                    }
                }
            }
            .padding(.horizontal, 32)
            SignBtmView(vmodel: vmodel.controlsVM)
        }
        .onChange(of: inFocus) { newValue in
            withAnimation {
                vmodel.inFocus = newValue
                vmodel.fieldVMs.forEach({ $0.inFocus = $0.field == newValue })
            }
        }
        .onChange(of: vmodel.inFocus) { inFocus = $0 }
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView(vmodel: SigninViewModel())
    }
}
