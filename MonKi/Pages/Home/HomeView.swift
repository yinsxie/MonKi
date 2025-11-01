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
    @StateObject var childlogViewModel = ChildLogViewModel()
    
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
                    navigationManager.goTo(.childGarden(.home(logToBePlanted: nil)))
                } label: {
                    Text("Nav to children garden")
                }
                
                Button {
                    navigationManager.goTo(.parentHome(.home)
                    )
                } label: {
                    Text("Nav to parent home")
                }
                
                Button {
                    navigationManager.goTo(.parentValue)
                } label: {
                    Text("Parent values")
                }
                
            }
            .navigationDestination(for: MainRoute.self) { route in
                switch route {
                case .childLog(let childLogRoute):
                    childLogRoute.delegateView()
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(childlogViewModel)
                case .childGarden(let childGardenRoute):
                    childGardenRoute.delegateView()
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(gardenViewModel)
                case .parentHome(let parentRoute):
                    parentRoute.delegateView()
                        .navigationBarBackButtonHidden(true)
                case .reLog(let log):
                    ReLogNavigationContainer(logToEdit: log)
                        .navigationBarBackButtonHidden(true)
                case .parentValue:
                    ParentValueTagView()
                }
            }
        }
        
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationManager())
}
