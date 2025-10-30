//
//  HomeView.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject var gardenViewModel = GardenViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationManager.navigationPath) {
            VStack(spacing: 20) {
                Text("Home View")
                
                Button {
                    navigationManager.goTo(.childLog(.logInput))
                } label: {
                    Text("Nav to children log")
                }
                
                Button {
                    navigationManager.goTo(.childGarden(.home))
                } label: {
                    Text("Nav to children garden")
                }
                
                Button {
                    navigationManager.goTo(.parentHome(.home)
                    )
                } label: {
                    Text("Nav to parent home")
                }
                
            }
            .navigationDestination(for: MainRoute.self) { route in
                switch route {
                case .childLog(let childLogRoute):
                    childLogRoute.delegateView()
                        .navigationBarBackButtonHidden(true)
                case .childGarden(let childGardenRoute):
                    childGardenRoute.delegateView()
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(gardenViewModel)
                case .parentHome(let parentRoute):
                    parentRoute.delegateView()
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
        
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationManager())
}
