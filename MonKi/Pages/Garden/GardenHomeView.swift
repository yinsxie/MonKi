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
    var bufferDataFromLogFull: GardenFullDataBuffer?
    
    init(bufferDataFromLogFull: GardenFullDataBuffer?) {
        self.bufferDataFromLogFull = bufferDataFromLogFull
    }
    
    var body: some View {
        ZStack {
            Image(GardenImageAsset.gardenBackground.imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            fieldView
            
            VStack {
                HStack {
                    if !viewModel.isShovelMode {
                        homeButton
                        Spacer()
                        collectibleButton
                    } else {
                        cancelButton
                        Spacer()
                    }
                }
                .padding(.top, 70)
                
                Spacer()
                //MARK: Uncomment to enable left and right
//                footerButtonView
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 57)
            
            popUpView
        
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.validateShovelMode(bufferData: bufferDataFromLogFull)
            viewModel.fetchLogData()
        }
    }
    
    @ViewBuilder
    var fieldView: some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            // Filter out archived logs before both rendering and counting
            let activeLogs = viewModel.logs.filter {
                if let state = $0.state {
                    return ChildrenLogState(state: state) != .archived
                }
                return false
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 70) {
                
                ForEach(activeLogs, id: \.self) { log in
                    let fieldState = FieldState(state: log.state ?? "")
                    fieldCardViewBuilder(for: log, type: fieldState)
                }
                
                // Now count fillers based on filtered logs
                if activeLogs.count < 4 {
                    ForEach(0..<(4 - activeLogs.count), id: \.self) { _ in
                        fieldCardViewBuilder(for: nil, type: .empty)
                    }
                }
            }
            .offset(y: 40)
        }
    }
    
    @ViewBuilder
    func fieldCardViewBuilder(for log: MsLog?, type: FieldState) -> some View {
        let image: UIImage? = {
            if let imagePath = log?.imagePath {
                return ImageStorage.loadImage(from: imagePath)
            } else {
                return nil
            }
        }()
        
        FieldCardView(type: type, logImage: image, isShovelMode: viewModel.isShovelMode) {
            viewModel.navigateTo(route: .childLog(.logInput), context: navigationManager)
        } onCTAButtonTapped: {
            print("CTA button tapped") 
            viewModel.handleCTAButtonTapped(forLog: log, withType: type, context: navigationManager, bufferData: bufferDataFromLogFull, logImage: image)
        }
    }
    
    @ViewBuilder
    var popUpView: some View {
        if let alert = viewModel.alertConfirmationType {
            PopUpView(type: alert) {
                withAnimation {
                    viewModel.enableShovelModeAlert(toType: nil)
                }
            }
        }
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
    
    var cancelButton: some View {
        CustomButton(
            backgroundColor: ColorPalette.yellow600,
            foregroundColor: ColorPalette.yellow400,
            textColor: ColorPalette.yellow50,
            font: .system(size: 20, weight: .black, design: .rounded),
            image: "xmark",
            action: {
                // Show confirmation popup to exit shovel mode
                // Prefer the buffered image; if missing, fall back to a placeholder asset
                let fallback = UIImage(named: "icecream_placeholder")
                let imageToUse = bufferDataFromLogFull?.image ?? fallback
                guard let imageToUse else { return }
                let alertType: GardenShovelModality = .exit(image: imageToUse) {
                    withAnimation { viewModel.isShovelMode = false }
                    // Dismiss the popup after confirming
                    viewModel.enableShovelModeAlert(toType: nil)
                }
                viewModel.enableShovelModeAlert(toType: alertType)
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
