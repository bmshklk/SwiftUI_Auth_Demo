//
//  Font.swift
//  MainTarget
//
//  Created by o.sander on 16.06.2023.
//  
//

import SwiftUI

public extension Font {
    // https://gist.github.com/zacwest/916d31da5d03405809c4
    private static let title1 = 28.0
    private static let title2 = 22.0
    private static let title3 = 20.0
    private static let headline = 17.0
    private static let body = 17.0
    private static let callout = 16.0
    private static let subheadline = 15.0
    private static let footnote = 13.0
    private static let caption = 12.0

    static var appTitle3: Font {
        poppins(size: Font.title3, relativeTo: .title3)
    }

    static var appTitle2: Font {
        poppins(size: Font.title2, relativeTo: .title2)
    }

    static var appTitle1: Font {
        poppins(size: Font.title2, relativeTo: .title2)
    }

    static var appHeadline: Font {
        poppins(weight: .semiBold, size: Font.headline, relativeTo: .headline)
    }

    static var appBody: Font {
        poppins(size: Font.body, relativeTo: .body)
    }

    static var appCallout: Font {
        poppins(size: Font.callout, relativeTo: .callout)
    }

    static var appSubheadline: Font {
        poppins(size: Font.subheadline, relativeTo: .subheadline)
    }

    static var appFootnote: Font {
        poppins(size: Font.footnote, relativeTo: .footnote)
    }

    static var appCaption: Font {
        poppins(size: Font.caption, relativeTo: .caption)
    }
}
