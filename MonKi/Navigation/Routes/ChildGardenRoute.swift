//
//  ChildGardenRoute.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

import SwiftUI

enum ChildGardenRoute: Hashable {
    case home
    case collectible
    case watering
    case harvesting
}

extension ChildGardenRoute {
    @ViewBuilder
    func delegateView() -> some View {
        switch self {
        case .home:
            GardenHomeView()
        case .collectible:
            CollectiblesHomeView()
        case .watering:
            GardenWateringView()
        case .harvesting:
            GardenHarvestingView()
        }
    }
}
