//
//  OnboardingRoute.swift
//  MonKi
//
//  Created by William on 06/11/25.
//

import SwiftUI

/// Ad this for garden
enum OnboardingRoute: SubRouteProtocol {
    case placeHolder
}

extension OnboardingRoute {
    @ViewBuilder
    func delegateView() -> some View {
        switch self {
        case .placeHolder:
            EmptyView()
        }
    }
}
