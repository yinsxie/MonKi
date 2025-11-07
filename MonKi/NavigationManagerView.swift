//
//  ContentView.swift
//  MonKi
//
//  Created by William on 24/10/25.
//

import SwiftUI

struct NavigationManagerView: View {
    
    @State private var isSplashShown: Bool = true
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject private var gateManager: ParentalGateManager
    @State private var isNewUser: Bool = true
    @State private var isLoadingAuth: Bool = true
    
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
                .fullScreenCover(item: $gateManager.gateDestination) { destination in
                    ParentalGateView(
                        viewModel: ParentalGateViewModel(
                            navigationManager: navigationManager,
                            onSuccess: {
                                gateManager.gateDestination = nil
                                switch destination {
                                case .parentSettings:
                                    navigationManager.goTo(.main(.parentValue))
                                    //                        case .reviewLogOnFirstLog:
                                    //                        case .reviewLogFromGarden:
                                    //                        case .checklistUpdate:
                                }
                            }
                        )
                    )
                }
        }
        .onAppear {
            //MARK: DEV purposes only
            setupAppFlow()
            handleAfterSplashScreen()
        }
    }
    
    func handleAfterSplashScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                if isNewUser {
                    navigationManager.changeRootAnimate(root: .onboarding(.landing))
                } else {
                    navigationManager.changeRootAnimate(root: .main(.garden))
                }
            }
        }
    }
    
    private func setupAppFlow() {
        self.isNewUser = UserDefaultsManager.shared.getIsNewUser() ?? true
        
        //        self.isLoadingAuth = false
        UserDefaultsManager.shared.initDevUserDefaults()
    }
}

#Preview {
    NavigationManagerView()
}
