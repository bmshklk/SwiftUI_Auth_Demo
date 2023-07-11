//
//  HomeAssembly.swift
//  MainTarget
//
//  Created by o.sander on 29.06.2023.
//  
//

import SwiftUI

class HomeAssembly {


    private let appAssembly: AppAssemblyProtocol
    private var storyboard: UIStoryboard { return UIStoryboard(name: "home", bundle: nil) }

    init(appAssembly: AppAssemblyProtocol) {
        self.appAssembly = appAssembly
    }
}

extension HomeAssembly {
    func assembleHomeViewController() -> HomeViewController {
        HomeViewController.from(storyboard: storyboard)
    }

    func assembleMenuController() -> UIHostingController<MenuView> {
        UIHostingController<MenuView>(rootView: MenuView(authService: appAssembly.services.authService()))
    }
}
