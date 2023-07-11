//
//  PoopinsFont.swift
//  MainTarget
//
//  Created by o.sander on 17.06.2023.
//  
//

import SwiftUI

extension UIFont {

    static func poppins(size: CGFloat, weight: PoppinsFontWeight = .regular) -> UIFont {
        let basename = "Poppins-"
        let fontname = basename + weight.suffix
        guard let font = UIFont(name: fontname, size: size)
        else {
            assertionFailure("Can't find poppins font for weight: \(weight)")
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        return font
    }
}

extension Font {

    static func poppinsFixed(size: CGFloat, weight: PoppinsFontWeight = .regular) -> Font {
        Font.custom("Poppins-\(weight.suffix)", fixedSize: size)
    }

    static func poppins(size: CGFloat, weight: PoppinsFontWeight = .regular) -> Font {
        Font.custom("Poppins-\(weight.suffix)", size: size)
    }

    static func poppins(weight: PoppinsFontWeight = .regular, size: CGFloat, relativeTo textStyle: TextStyle = .body) -> Font {
        Font.custom("Poppins-\(weight.suffix)", size: size, relativeTo: textStyle)
    }
}

enum PoppinsFontWeight {
    case black
    case blackItalic
    case bold
    case boldItalic
    case extraBold
    case extraBoldItalic
    case extraLight
    case extraLightItalic
    case italic
    case light
    case lightItalic
    case medium
    case mediumItalic
    case regular
    case semiBold
    case semiBoldItalic
    case thin
    case thinItalic
}

private extension PoppinsFontWeight {
    var suffix: String {
        switch self {
        case .black:            return "Black"
        case .blackItalic:      return "BlackItalic"
        case .bold:             return "Bold"
        case .boldItalic:       return "BoldItalic"
        case .extraBold:        return "ExtraBold"
        case .extraBoldItalic:  return "ExtraBoldItalic"
        case .extraLight:       return "ExtraLight"
        case .extraLightItalic: return "ExtraLightItalic"
        case .italic:           return "Italic"
        case .light:            return "Light"
        case .lightItalic:      return "LightItalic"
        case .medium:           return "Medium"
        case .mediumItalic:     return "MediumItalic"
        case .regular:          return "Regular"
        case .semiBold:         return "SemiBold"
        case .semiBoldItalic:   return "SemiBoldItalic"
        case .thin:             return "Thin"
        case .thinItalic:       return "ThinItalic"
        }
    }
}
