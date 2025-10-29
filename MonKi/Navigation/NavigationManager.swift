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
        if navigationPath.isEmpty { return }
        navigationPath.removeAll()
    }
    
    func popLast() {
        if navigationPath.isEmpty { return }
        _ = navigationPath.popLast()
    }
    
    func pop(times n: Int) {
        guard n > 0 else { return }
        let countToRemove = min(n, navigationPath.count)
        navigationPath.removeLast(countToRemove)
    }

    func replaceTop(with route: MainRoute) {
        guard !navigationPath.isEmpty else {
            navigationPath.append(route)
            return
        }
        
        navigationPath[navigationPath.count - 1] = route
    }
    
    func replaceTopAnimate(with route: MainRoute) {
        guard !navigationPath.isEmpty else {
            navigationPath.append(route)
            return
        }

        navigationPath.removeLast()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                self.navigationPath.append(route)
            }
        }
    }
}
