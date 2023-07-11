//
//  BaseRouter.swift
//  MainTarget
//
//  Created by o.sander on 09.06.2023.
//  
//

import UIKit

enum TransitionMethod {

    case push
    case present(_ modalPresentationStyle: UIModalPresentationStyle? = nil)
}

class BaseRouter {

    private(set) var transition: TransitionMethod?

    private var navigationAnchorController: UIViewController?
    private var initialController: UIViewController?

    func push(viewController: UIViewController, fromViewController: UIViewController, animated: Bool, completion: VoidBlock? = nil) {

        let requiredNavigationViewController: UINavigationController
        if let navVC = fromViewController as? UINavigationController {
            requiredNavigationViewController = navVC
        }
        else if let navVC = fromViewController.navigationController {
            requiredNavigationViewController = navVC
        }
        else {
            return
        }

        requiredNavigationViewController.push(controller: viewController, animated: animated)
    }

    func pop(viewController: UIViewController, animated: Bool, completion: VoidBlock? = nil) {

        guard let requiredNavigationViewController = viewController.navigationController
        else {
            return
        }

        requiredNavigationViewController.popViewController(animated: animated)

        let deadline: DispatchTime = animated ? .now() + 0.3 : .now()

        DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
            if let requiredCompletion = completion {
                requiredCompletion()
            }
        })
    }

    func show(initialController: UIViewController,
               transitionMethod: TransitionMethod,
            from viewController: UIViewController,
                       animated: Bool,
                     completion: VoidBlock? = nil) {

        self.transition = transitionMethod
        self.initialController = initialController

        switch transitionMethod {
        case .present(let modalPresentationStyle):
            initialController.modalPresentationStyle = modalPresentationStyle ?? .fullScreen
            viewController.present(initialController, animated: animated, completion: completion)
        case .push:
            guard let navigationViewController = self.navigationViewController(of: viewController)
            else {
                completion?()
                return
            }

            self.navigationAnchorController = navigationViewController.viewControllers.last

            if let initialNavigationStack = initialController as? UINavigationController {
                navigationViewController.push(controllers: initialNavigationStack.viewControllers, animated: animated)
            }
            else {
                navigationViewController.push(controller: initialController, animated: animated)
            }

            if let requiredCompletion = completion {

                let deadline: DispatchTime = animated ? .now() + 0.3 : .now()

                DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
                    requiredCompletion()
                })
            }
        }
    }

    func hide(animated: Bool,
            completion: VoidBlock? = nil) {

        guard let requiredTransitionMethod = self.transition
        else {
            return
        }

        switch requiredTransitionMethod {
        case .present:
            guard let requiredInitialViewController = self.initialController
            else {
                completion?()
                return
            }

            requiredInitialViewController.dismiss(animated: animated, completion: completion)

        case .push:
            if let requiredAnchorController = navigationAnchorController,
               let requiredNavigationViewController = self.navigationViewController(of: requiredAnchorController) {

                requiredNavigationViewController.popToViewController(requiredAnchorController, animated: animated)
            }

            if let requiredCompletion = completion {

                let deadline: DispatchTime = animated ? .now() + 0.3 : .now()

                DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
                    requiredCompletion()
                })
            }
        }

        self.transition = nil
        self.navigationAnchorController = nil
        self.initialController = nil
    }

    func navigationViewController(of viewController: UIViewController) -> UINavigationController? {

        let navigationViewController: UINavigationController
        if let navVC = viewController as? UINavigationController {
            navigationViewController = navVC
        }
        else if let navVC = viewController.navigationController {
            navigationViewController = navVC
        }
        else {
            return nil
        }

        return navigationViewController
    }
}
