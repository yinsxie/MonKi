//
//  GardenWateringView.swift
//  MonKi
//
//  Created by William on 29/10/25.
//

import SwiftUI

struct GardenWateringView: View {
    
    private var listOfFrame = GardenWateringAsset.allCases
    @State private var frame: GardenWateringAsset = .frame1
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var viewModel: GardenViewModel
    
    @State private var fieldState: FieldState = .approved
    
    var body: some View {
        ZStack {
            Image(frame.imageName)
                .resizable()
                .ignoresSafeArea()
            
            if let fieldAsset = fieldState.fieldAsset {
                ZStack {
                    Image(fieldAsset)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190)
                        .offset(y: fieldState == .done ? 33: 50)
                    if let thoughtBubbleImage = fieldState.thoughtBubbleImage {
                        ZStack {
                            Image(thoughtBubbleImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200)
                           
                            if let image = viewModel.imageEventBuffer {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 66)
                                    .offset(y: -20)

                            }
                        }
                        .offset(x: -85, y: -90)
                    }
                }
                
            }
            
            if frame == .frame1 {
                Image(GardenWateringHelperAsset.wateringCan.imageName)
                    .resizable()
            }
           
            if frame == .frame2 {
                VStack {
                    Spacer()
                   CustomCTAButton(
                    text: "Kembali ke Kebun",
                    backgroundColor: ColorPalette.blue900,
                    foregroundColor: ColorPalette.blue600, textColor: ColorPalette.neutral50,
                    font: .calloutEmphasized,
                    horizontalPadding: 18,
                    verticalPadding: 18,
                   ) {
                       viewModel.navigateBack(context: navigationManager)
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
                fieldState = .done
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationManager())
}
