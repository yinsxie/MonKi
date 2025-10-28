//
//  HomeView.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
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
                    navigationManager.goTo(.childGarden(.garden))
                } label: {
                    Text("Nav to children garden")
                }
                
                Button {
                    
                } label: {
                    Text("Nav to parent home")
                }
                
            }
            .navigationDestination(for: MainRoute.self) { route in
                switch route {
                case .childLog(let childLogRoute):
                    childLogRoute.delegateView()
                case .childGarden(let childGardenRoute):
                    childGardenRoute.delegateView()
                case .parentHome(let parentRoute):
                    parentRoute.delegateView()
                }
            }
        }
        
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationManager())
}
