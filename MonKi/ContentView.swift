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
    @State private var isNewUser: Bool = true
    @State private var isLoadingAuth: Bool = true
    
    var body: some View {
        VStack {
            if isSplashShown || isLoadingAuth {
                SplashScreenView()
            } else if isNewUser {
                NavigationStack {
                    ParentalGateSettingView(
                        viewModel: ParentalGateSettingViewModel(
                            onFinished: {
                                withAnimation {
                                    self.isNewUser = false
                                }
                            }
                        )
                    )
                }
                .environmentObject(navigationManager)
                .transition(.opacity.animation(.easeInOut))
                
            } else {
                HomeView()
                    .environmentObject(navigationManager)
            }
        }
        .onAppear {
            //MARK: DEV purposes only
            setupAppFlow()
        }
    }
    
    private func setupAppFlow() {
        self.isNewUser = UserDefaultsManager.shared.getIsNewUser() ?? true
        
        self.isLoadingAuth = false
        UserDefaultsManager.shared.initDevUserDefaults()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                isSplashShown = false
            }
        }
    }
}

#Preview {
    ContentView()
}
