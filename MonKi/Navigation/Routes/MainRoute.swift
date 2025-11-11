//
//  MainRoute.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

// Main Route
// - Relog
// - Log
// - Parent Gate
// - Parent Value
// - Collectible

import SwiftUI

/// Defines the main routes (after splash onboarding, basically garden ini)
/// Main
enum MainRoute: SubRouteProtocol {
    case placeHolder
}

extension MainRoute {
    @ViewBuilder
    func delegateView() -> some View {
        switch self {
        case .placeHolder:
            Text("Halo")
        }
    }
}
