//
//  GardenHarvestingView.swift
//  MonKi
//
//  Created by William on 29/10/25.
//

import SwiftUI

struct GardenHarvestingView: View {
    
    @State private var frame: GardenHarvestingAsset = .frame1
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var viewModel: GardenViewModel
    
    var logImage: UIImage
    @State private var fieldState: FieldState = .done
    
    init(logImage: UIImage = UIImage(named: ColoredPencilAsset.canvasViewBlackPencil.imageName)!) {
        self.logImage = logImage
    }
    
    var body: some View {
        ZStack {
            Image(frame.imageName)
                .resizable()
                .ignoresSafeArea()
            
            if frame == .frame1, let fieldAsset = fieldState.fieldAsset, let thoughtBubbleImage = fieldState.thoughtBubbleImage {
                ZStack {
                    Image(fieldAsset)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190)
                        .offset(y: fieldState == .done ? 33: 50)
                    
                    ZStack {
                        Image(thoughtBubbleImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                        
                        Image(uiImage: logImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 66)
                            .offset(y: -20)
                    }
                    .offset(x: -85, y: -90)
                }
                
            }
            
            if frame == .frame1 {
                Image(GardenHarvestingHelperAsset.hand.imageName)
                    .resizable()
            }
            
            if frame == .frame2 {
                VStack {
                    Spacer()
                    Image(uiImage: logImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 328)
                    
                    Spacer()
                    CustomCTAButton(
                        text: "Lihat Buku Koleksi",
                        backgroundColor: ColorPalette.blue900,
                        foregroundColor: ColorPalette.blue600, textColor: ColorPalette.neutral50,
                        font: .calloutEmphasized,
                        horizontalPadding: 18,
                        verticalPadding: 18,
                    ) {
                        viewModel.pushReplaceToCollectibleView(context: navigationManager)
                    }
                }
                .padding(.bottom, 32)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    frame = .frame2
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationManager())
}
