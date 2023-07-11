//
//  NextButtonStyle.swift
//  MainTarget
//
//  Created by o.sander on 27.06.2023.
//  
//

import SwiftUI

struct NextButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.poppinsFixed(size: 15, weight: .bold))
            .foregroundColor(configuration.isPressed ? .white.opacity(0.3) : .white)
            .frame(width: 224, height: 58)
            .background(
                LinearGradient.general
            )
            .clipShape(
                Capsule()
            )
    }
}

extension ButtonStyle where Self == NextButtonStyle {
    static var next: NextButtonStyle { .init() }
}
