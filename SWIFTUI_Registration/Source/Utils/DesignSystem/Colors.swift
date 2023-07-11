//
//  Colors.swift
//  MainTarget
//
//  Created by o.sander on 16.06.2023.
//  
//

import SwiftUI

struct Colors {
    static var primary: Color { Color("primary") }
    static var backgoundColor: Color { Color("backgoundColor") }

    static var rose1: Color { Color("rose1") }
    static var rose2: Color { Color("rose2") }

    static var menu: Color { Color("menu") }
}

extension Color {
  init(_ hex: UInt, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xFF) / 255,
      green: Double((hex >> 8) & 0xFF) / 255,
      blue: Double(hex & 0xFF) / 255,
      opacity: alpha
    )
  }
}

extension LinearGradient {
    static var general: LinearGradient {
        LinearGradient(colors: [Colors.rose1, Colors.rose2],
                       startPoint: UnitPoint(x: -0.5, y: 0.5),
                       endPoint: UnitPoint(x: 0.5, y: 1.5)
        )
    }
}
