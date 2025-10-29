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
    
    func navigateBack(context: NavigationManager) {
        context.popLast()
    }
    
    func onFieldTapped(forFieldType: FieldState, context: NavigationManager) {
        switch forFieldType {
        case .empty:
            context.goTo(.childLog(.logInput))
        default:
            return
        }
            
    }
    
    func handleCTAButtonTapped(for type: FieldState, context: NavigationManager) {
        switch type {
        case .approved:
           onApproveFieldTapped(context: context)
        case .done:
            onDoneFieldTapped(context: context)
        default:
            return
        }
    }
}

private extension GardenViewModel {
    
    func onApproveFieldTapped(context: NavigationManager) {
        context.goTo(.childGarden(.watering))
        // TODO: Update State to Done
    }
    
    func onDoneFieldTapped(context: NavigationManager) {
        context.goTo(.childGarden(.harvesting))
        // TODO: Update State to Archieved (removing it from the field basically)
    }
}
