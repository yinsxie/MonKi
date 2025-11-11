//
//  AnimatedShineView.swift
//  MonKi
//
//  Created by William on 06/11/25.
//

import SwiftUI

struct AnimatedShineView: View {
    
    @State private var rotate = 0.0
    
    let BGRay = "BGShineRay"
    let BGShineStars = "BGShineStars"
    let BGCircle = "BGShineCircle"
    
    var body: some View {
        ZStack {
            
            Image(BGCircle)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
            
            Image(BGRay)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
                .rotationEffect(.degrees(rotate))
                .onAppear {
                    withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                        rotate = 360
                    }
                }
            
            Image(BGShineStars)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    AnimatedShineView()
}
