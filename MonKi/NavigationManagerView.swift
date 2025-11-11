//
//  ContentView.swift
//  MonKi
//
//  Created by William on 24/10/25.
//

import SwiftUI

struct NavigationManagerView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        
        /// The main navigation stack that handles the app's navigation flow.
        NavigationStack(path: $navigationManager.navigationPath) {
            navigationManager.buildRoot(navigationManager.root)
                .navigationDestination(for: RootRoute.self, destination: { route in
                    switch route {
                    case .main(let mainRoute):
                        mainRoute.delegateView()
                            .navigationBarBackButtonHidden(true)
                    case .onboarding(let onBoardingRoute):
                        onBoardingRoute.delegateView()
                            .navigationBarBackButtonHidden(true)
                    default:
                        SplashScreenView()
                            .navigationBarBackButtonHidden(true)
                    }
                })
        }
        .onAppear {
            setupAppFlow()
            endSplashView()
        }
    }
    
    private func endSplashView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            navigationManager.changeRootAnimate(root: .main(.placeHolder))
        }
    }
    
    private func setupAppFlow() {
    }
}

#Preview {
    NavigationManagerView()
}
