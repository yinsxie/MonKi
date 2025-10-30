//
//  CollectiblesHomeView.swift
//  MonKi
//
//  Created by William on 29/10/25.
//

import SwiftUI

struct CollectiblesHomeView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack {
            Text("CollectiblesHomeView")
            
            Button {
                navigationManager.popLast()
            } label: {
                Text("Go back")
            }
            
        }
        
        
    }
}
