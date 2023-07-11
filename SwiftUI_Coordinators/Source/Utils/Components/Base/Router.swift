//
//  RouterPath.swift
//  SwiftUI_Coordinators
//
//  Created by o.sander on 10.07.2023.
//

import SwiftUI

class Router<Destination: Hashable & Identifiable>: ObservableObject {

    struct State {
        var navigationPath: [Destination] = []
        var presentingSheet: Destination? = nil
        var presentingFullScreen: Destination? = nil

        var isPresenting: Bool {
            presentingSheet != nil || presentingFullScreen != nil
        }
    }

    @Published private(set) var state = State()

    deinit {
        print("☠️ \(String(describing: self))")
    }
    
    func navigate(to destination: Destination) {
        state.navigationPath.append(destination)
    }

    func pop() {
        state.navigationPath.removeLast()
    }

    func popToRoot() {
        state.navigationPath.removeLast(state.navigationPath.count)
    }

    func replace(navigationStack: [Destination]) {
        state.navigationPath = .init(navigationStack)
    }

    func presentSheet(_ destination: Destination) {
        state.presentingSheet = destination
    }

    func presentFullScreen(_ destination: Destination) {
        state.presentingFullScreen = destination
    }

    func dismiss() {
        if state.presentingSheet != nil {
            state.presentingSheet = nil
        } else if state.presentingFullScreen != nil {
            state.presentingFullScreen = nil
        } else if state.navigationPath.count > 0 {
            state.navigationPath.removeLast()
        }
    }
}

extension Router {

    var path: Binding<[Destination]> {
        binding(keyPath: \.navigationPath)
    }

    var presentingSheet: Binding<Destination?> {
        binding(keyPath: \.presentingSheet)
    }

    var presentingFullScreen: Binding<Destination?> {
        binding(keyPath: \.presentingFullScreen)
    }
}

private extension Router {

    func binding<T>(keyPath: WritableKeyPath<State, T>) -> Binding<T> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
}
