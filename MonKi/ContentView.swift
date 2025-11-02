//
//  ContentView.swift
//  MonKi
//
//  Created by William on 24/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isSplashShown: Bool = true
    @StateObject var navigationManager = NavigationManager()
    
    var body: some View {
        VStack {
            if isSplashShown {
                SplashScreenView()
            } else {
                HomeView()
                    .environmentObject(navigationManager)
            }
        }
        .onAppear {
            //MARK: DEV purposes only
            UserDefaultsManager.shared.initDevUserDefaults()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isSplashShown = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
