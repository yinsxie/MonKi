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
    @State var isShovelMode: Bool = false
    let bufferDataFromLogFull: GardenFullDataBuffer? = nil
    
    init(bufferDataFromLogFull: GardenFullDataBuffer?) {
        _isShovelMode = State(initialValue: bufferDataFromLogFull != nil)
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
                    if !isShovelMode {
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
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
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
        //TODO: Gnti ke ImageStorage.loadImage(from: String) kalau inputLog udh
        let image: UIImage? = {
            if let imagePath = log?.imagePath {
                return UIImage(named: imagePath)
            } else {
                return nil
            }
        }()
        FieldCardView(type: type, logImage: image) {
            viewModel.navigateTo(route: .childLog(.logInput), context: navigationManager)
        } onCTAButtonTapped: {
            print("CTA button tapped")
            viewModel.handleCTAButtonTapped(forLog: log, withType: type, context: navigationManager)
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
