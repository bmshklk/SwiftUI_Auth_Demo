//
//  HomeRouter.swift
//  MainTarget
//
//  Created by o.sander on 29.06.2023.
//  
//

import UIKit

class HomeRouter: BaseRouter {

    private let assembly: HomeAssembly
    init(assembly: HomeAssembly) {
        self.assembly = assembly
    }
    
    func showHomeStory(in controller: UINavigationController, animated: Bool) {
        let vc = assembly.assembleHomeViewController()
        vc.menuAction = { [weak self] homeVC in
            self?.showMenuController(from: homeVC)
        }
        controller.setViewControllers([vc], animated: animated)
    }
}

private extension HomeRouter {
    func showMenuController(from controller: UIViewController) {
        let vc = assembly.assembleMenuController()
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in 180 })]
            sheet.prefersGrabberVisible = true
        }

        controller.present(vc, animated: true)
    }
}
