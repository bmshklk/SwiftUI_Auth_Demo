//
//  MaterialTextFieldOutlined.swift
//  MainTarget
//
//  Created by o.sander on 11.06.2023.
//  
//

import SwiftUI
import Combine

extension MaterialTFVM {

    enum PromptAppearance {
        case empty
        case hint(String)
        case error(String)
    }

    struct Style {
        let textColor: Color
        let activeTintColor: Color
        let errorTintColor: Color
        let normalTintColor: Color
        let backgroundColor: Color
        let placeholderColor: Color
        let hintColor: Color

        static var preview: Style {
            Style(textColor: .black,
                  activeTintColor: .accentColor,
                  errorTintColor: .red,
                  normalTintColor: .gray,
                  backgroundColor: .gray.opacity(0.1),
                  placeholderColor: .gray,
                  hintColor: .gray)
        }
    }
}

class MaterialTFVM: ObservableObject, Identifiable {

    var autocapitalization: TextInputAutocapitalization = .never
    let style: Style
    let placeholder: String
    let hint: String?
    let textContent: UITextContentType?
    let id: String

    @Published var error: String? = nil
    @Published var inFocus: Bool = false
    @Published var text: String = ""
    @Published var isSecure: Bool

    init(id: String,
         style: MaterialTFVM.Style = .preview,
         placeholer: String = "",
         hint: String? = nil,
         textContent: UITextContentType? = nil, isSecure: Bool = false) {
        self.id = id
        self.style = style
        self.placeholder = placeholer
        self.hint = hint
        self.textContent = textContent
        self.isSecure = isSecure
    }

    var isPlaceholderOnTop: Bool {
        !text.isEmpty || inFocus
    }

    var isPassword: Bool {
        guard let textContent else { return false }
        return [UITextContentType.password, .newPassword].contains(textContent)
    }

    var underlineColor: Color {
        inFocus ? style.activeTintColor : style.normalTintColor
    }

    var promtAppearance: PromptAppearance {
        if let error {
            return .error(error)
        } else if let hint {
            return .hint(hint)
        } else {
            return .empty
        }
    }
}

struct MaterialTextField: View {
    @ObservedObject var vmodel: MaterialTFVM

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                HStack {
                    Group {
                        if vmodel.isSecure {
                            SecureField("", text: $vmodel.text)
                        } else {
                            TextField("", text: $vmodel.text)
                        }
                    }
                    .iflet(vmodel.textContent, { view, value in
                        view.textContentType(value)
                    })
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(vmodel.autocapitalization)
                    .foregroundColor(Colors.primary)
                    .frame(minHeight: 44.0)
                    .padding(.top, 10)

                    if vmodel.isPassword {
                        Button {
                            vmodel.isSecure.toggle()
                        } label: {
                            Image(systemName: vmodel.isSecure ? "eye.slash" : "eye")
                                .foregroundColor(Colors.primary)
                                .padding(.trailing, 8)
                                .frame(width: 44, height: 44)
                        }
                    }
                }
                .background(alignment: vmodel.isPlaceholderOnTop ? .topLeading : .leading) {
                    Text(vmodel.placeholder)
                        .font(.poppinsFixed(size: 13.0))
                        .scaleEffect(vmodel.isPlaceholderOnTop ? 0.8 : 1, anchor: .leading)
                        .offset(y: vmodel.isPlaceholderOnTop ? 0 : 5)
                        .foregroundColor(vmodel.style.placeholderColor)
                }
                Rectangle()
                    .fill(vmodel.underlineColor)
                    .frame(height: vmodel.inFocus ? 2.0 : 1)
                promptView
                    .padding(.top, 4)
            }
        }
        .background(vmodel.style.backgroundColor)
        .cornerRadius(5)
    }

    @ViewBuilder
    var promptView: some View {
        HStack {
            Group {
                switch vmodel.promtAppearance  {
                case .empty: EmptyView()
                case .error(let error):
                    Text(error)
                        .foregroundColor(vmodel.style.errorTintColor)
                case .hint(let hint):
                    Text(hint)
                        .foregroundColor(vmodel.style.normalTintColor)
                }
            }
            .font(.appCaption)
            .foregroundColor(vmodel.style.hintColor)
            .padding(.bottom, 6)
            Spacer()
        }
    }

}

struct MaterialTextField_Previews: PreviewProvider {
    static let previewVM = MaterialTFVM(id: UUID().uuidString,
                                        placeholer: "Username",
                                        hint: "Little user hint",
                                        textContent: .password)
    static var previews: some View {
        MaterialTextField(vmodel: previewVM)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
