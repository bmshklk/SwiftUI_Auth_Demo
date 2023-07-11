//
//  HomeRouter.swift
//  MainTarget
//
//  Created by o.sander on 29.06.2023.
//  
//

import SwiftUI

extension HomeRouter {
    enum Directions: Hashable, Identifiable {
        case menu
        var id: String { String(describing: self) }
    }
}

class HomeRouter: Router<HomeRouter.Directions> {

    func homeView() -> HomeView {
        HomeView { [weak self] in
            self?.presentSheet(.menu)
        }
    }

    func menuView() -> MenuView {
        MenuView()
    }
}

struct HomeRouterView: View {
    @StateObject private var router: HomeRouter

    init(router: HomeRouter) {
        _router = StateObject(wrappedValue: router)
    }

    var body: some View {
        router.homeView()
            .sheet(item: router.presentingSheet) { direction in
                switch direction {
                case .menu:
                    router.menuView()
                        .presentationDetents([.height(180)])
                        .presentationCornerRadius(22)
                }
            }
    }
}
