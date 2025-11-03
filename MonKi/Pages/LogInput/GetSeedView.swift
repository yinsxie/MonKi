//
//  GetSeedView.swift
//  MonKi
//
//  Created by William on 03/11/25.
//

import SwiftUI

struct GetSeedView: View {
    
    let logImage: UIImage?
    
    @State private var isMoveToNextSequence = false
    @EnvironmentObject var navigationManager: NavigationManager
    
    let imageAssetShine = "FinalLogShine"
    //MARK: Design gonna be changed, be sure to change it later
    let seedPlaceHolder = "seed_placeholder"
    let spacing: CGFloat = 120.0
    
    let plantBackground = "FinalPlantBackground"
    let state: FieldState = .approved
    
    var body: some View {
        VStack {
            if !isMoveToNextSequence {
                seedGainedImageView
            } else {
                seedPlantedPromptView
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    isMoveToNextSequence = true
                }
            }
        }
    }
    
    var seedGainedImageView: some View {
        ZStack {
            Image(imageAssetShine)
                .resizable()
                .scaledToFill()
            
            GeometryReader { geometry in
                VStack(spacing: spacing) {
                    Text("+1 Benih")
                        .font(.largeTitleSemibold)
                        .foregroundStyle(ColorPalette.orange500)

                    Image(seedPlaceHolder)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 125)
                }
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2 - spacing / 2 // adjust slightly if spacing or text height changes
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    var seedPlantedPromptView: some View {
        ZStack {
            Image(plantBackground)
                .resizable()
                .scaledToFill()
            
            VStack {
                Spacer()
                
                Text("Nih kids yuk tunggu respon parent")
                    .font(.title1Semibold)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                potView
                
                Spacer()

                CustomButton(
                    colorSet: .primary,
                    font: .system(size: 36, weight: .black, design: .rounded),
                    image: "arrow.right",
                    action: {
                        navigationManager.popToRoot()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            navigationManager.goTo(.childGarden(.home(logToBePlanted: nil)))
                        }
                    },
                    type: .normal
                )
            }
            .padding(.horizontal, 21)
            .padding(.bottom, 56)
        }
    }
    
    @ViewBuilder
    var potView: some View {
        ZStack {
            if let fieldAsset = state.fieldAsset {
                Image(fieldAsset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 158)
                    .offset(y: -25)
            }
            
            ZStack {
                if let thoughtBubbleImage = state.thoughtBubbleImage, let logImage = logImage {
                    Image(thoughtBubbleImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 192)
                        
                    Image(uiImage: logImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 38)
                        .offset(y: -20)
                }
            }
            .offset(x: -90, y: -140)
        }
    }
    
    init(logImage: UIImage?) {
        self.logImage = logImage
    }
}

//#Preview {
//    GetSeedView(logImage: UIImage(named: "icecream_placeholder"))
//}

#Preview {
    HomeView()
        .environmentObject(NavigationManager())
}
