//
//  MonKiApp.swift
//  MonKi
//
//  Created by William on 24/10/25.
//

import SwiftUI

@main
struct MonKiApp: App {

    @StateObject var navigationManager = NavigationManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationManagerView()
                .environmentObject(navigationManager)
        }
    }
}
