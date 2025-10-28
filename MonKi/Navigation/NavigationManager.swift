//
//  NavigationManager.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

import SwiftUI

final class NavigationManager: ObservableObject {
    @Published var navigationPath: [MainRoute] = []
    
    func goTo(_ route: MainRoute) {
        navigationPath.append(route)
    }
    
    func popToRoot() {
        navigationPath.removeAll()
    }
    
    func popLast() {
        _ = navigationPath.popLast()
    }
    
    func replaceTop(with route: MainRoute) {
        guard !navigationPath.isEmpty else {
            navigationPath.append(route)
            return
        }
        navigationPath[navigationPath.count - 1] = route
    }
}
