//
//  GardenHomeView.swift
//  MonKi
//
//  Created by William on 29/10/25.
//

import SwiftUI

struct GardenHomeView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var viewModel: GardenViewModel
    
    var body: some View {
        ZStack {
            Image(GardenImageAsset.gardenBackground.imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    homeButton
                    Spacer()
                    collectibleButton
                }
                .padding(.top, 70)
                
                Spacer(minLength: 180)
               
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 60) {
                    ForEach(0..<4) { _ in
                        FieldCardView(type: .empty, gardenViewModel: viewModel, context: navigationManager)
                    }
                }
                
                Spacer()
                
                //MARK: Uncomment to enable left and right
//                footerButtonView
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 57)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var footerButtonView: some View {
        HStack {
            CustomButton(
                backgroundColor: ColorPalette.yellow600,
                foregroundColor: ColorPalette.yellow400,
                textColor: ColorPalette.yellow50,
                font: .system(size: 20, weight: .black, design: .rounded),
                image: "arrow.left",
                action: {
                },
                cornerRadius: 24,
                width: 64,
                type: .normal
            )
            
            Spacer()
            
            CustomButton(
                backgroundColor: ColorPalette.yellow600,
                foregroundColor: ColorPalette.yellow400,
                textColor: ColorPalette.yellow50,
                font: .system(size: 20, weight: .black, design: .rounded),
                image: "arrow.right",
                action: {
                },
                cornerRadius: 24,
                width: 64,
                type: .normal
            )

        }
    }
    
    var collectibleButton: some View {
        CustomButton(
            backgroundColor: ColorPalette.yellow600,
            foregroundColor: ColorPalette.yellow400,
            textColor: ColorPalette.yellow50,
            font: .system(size: 20, weight: .black, design: .rounded),
            image: "book.pages.fill",
            action: {
                viewModel.navigateTo(route: .childGarden(.collectible), context: navigationManager)
            },
            cornerRadius: 24,
            width: 64,
            type: .normal
        )
    }
    
    var homeButton: some View {
        CustomButton(
            backgroundColor: ColorPalette.yellow600,
            foregroundColor: ColorPalette.yellow400,
            textColor: ColorPalette.yellow50,
            font: .system(size: 20, weight: .black, design: .rounded),
            image: "house.fill",
            action: {
                viewModel.navigateToHome(context: navigationManager)
            },
            cornerRadius: 24,
            width: 64,
            type: .normal
        )
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationManager())
}
