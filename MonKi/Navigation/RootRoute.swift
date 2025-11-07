//
//  RootRoute.swift
//  MonKi
//
//  Created by William on 06/11/25.
//

/// Defines the Root Routes of the Application
enum RootRoute: Hashable {
    case splashScreen
    case main(MainRoute)
    case onboarding(OnboardingRoute)
}
