//
//  SignupView.swift
//  MainTarget
//
//  Created by o.sander on 11.06.2023.
//  
//

import SwiftUI

struct SignupView: View {

    @ObservedObject var vmodel: SignupViewModel
    @FocusState private var inFocus: AuthField?

    var body: some View {
        ZStack {
            Colors.backgoundColor.ignoresSafeArea()
            ScrollView {
                VStack {
                    Image("illustration_signup")
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Create account")
                            .font(.appTitle3)
                            .foregroundColor(Colors.rose1)
                            .bold()
                        Text("Hi, kindly fill in the form to proceed \ncombat")
                            .font(.body)
                            .foregroundColor(Colors.primary)
                            .lineLimit(nil)
                        Spacer().frame(height: 12)
                        ForEach(vmodel.fieldVMs) {
                            MaterialTextField(vmodel: $0)
                                .focused($inFocus, equals: $0.field)
                                .submitLabel($0.field == .confirmPassword ? .done : .next)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(EdgeInsets(top: 26, leading: 32, bottom: 37, trailing: 32))
                    SignBtmView(vmodel: vmodel.controlsVM)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .onChange(of: inFocus) { newValue in
                    withAnimation {
                        vmodel.inFocus = newValue
                        vmodel.fieldVMs.forEach({ $0.inFocus = $0.field == newValue })
                    }
                }
                .onChange(of: vmodel.inFocus) { inFocus = $0 }
                .onSubmit {
                    withAnimation {
                        vmodel.toggleFocus()
                    }
                }
            }
        }
    }
}

extension MaterialTFVM {
    var field: AuthField {
        AuthField(rawValue: id)!
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(vmodel: SignupViewModel())
    }
}
