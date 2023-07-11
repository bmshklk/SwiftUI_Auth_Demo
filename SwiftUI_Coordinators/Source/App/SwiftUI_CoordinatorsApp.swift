//
//  SwiftUI_CoordinatorsApp.swift
//  SwiftUI_Coordinators
//
//  Created by o.sander on 08.07.2023.
//

import SwiftUI

@main
struct SwiftUI_CoordinatorsApp: App {

    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            AppRouterView()
        }
    }
}
