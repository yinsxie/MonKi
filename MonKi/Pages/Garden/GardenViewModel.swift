//
//  GardenViewModel.swift
//  MonKi
//
//  Created by William on 29/10/25.
//

import SwiftUI

final class GardenViewModel: ObservableObject {
    
    func navigateToHome(context: NavigationManager) {
        context.popLast()
    }
    
    func navigateTo(route: MainRoute, context: NavigationManager) {
        context.goTo(route)
    }
    
    func onFieldTapped(forFieldType: FieldState, context: NavigationManager){
        switch forFieldType {
        case .empty:
            context.goTo(.childLog(.logInput))
        default:
            print("belum")
        }
            
    }
}
