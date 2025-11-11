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
    case garden
    case relog(log: MsLog)
    case log
    case parentVerdict(log: MsLog)
    case parentValue
    case collectible
}

extension MainRoute {
    @ViewBuilder
    func delegateView() -> some View {
        switch self {
        case .garden:
            GardenHomeView()
        case .collectible:
            CollectiblesHomeView()
        case .log:
            ChildLogNavigationContainer()
        case .parentVerdict(let log):
            EmptyView()
        case .relog(let log):
            EmptyView()
        case .parentValue:
            ParentValueTagView()
        }
    }
}
