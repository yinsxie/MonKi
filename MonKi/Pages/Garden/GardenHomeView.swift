//
//  GardenHomeView.swift
//  MonKi
//
//  Created by William on 29/10/25.
//

import SwiftUI

struct GardenHomeView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var gateManager: ParentalGateManager
    @StateObject private var viewModel = GardenViewModel()
    @StateObject var childlogViewModel = ChildLogViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationManager.navigationPath) {
            ZStack {
                Image(GardenImageAsset.gardenBackground.imageName)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                fieldView
                
                VStack {
                    HStack {
                        parentButton
                        Spacer()
                        collectibleButton
                    }
                    .padding(.top, 70)
                    
                    Spacer()
                    //MARK: Uncomment to enable left and right
                    footerButtonView
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 57)
                
                popUpView
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                viewModel.fetchLogData()
            }
            .navigationDestination(for: MainRoute.self) { route in
                switch route {
                case .log:
                    ChildLogNavigationContainer()
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(childlogViewModel)
                case .collectible:
                    CollectiblesHomeView()
                        .navigationBarBackButtonHidden(true)
                case .relog(let log):
                    ReLogNavigationContainer(logToEdit: log)
                        .navigationBarBackButtonHidden(true)
                case .parentValue:
                    ParentValueTagView()
                        .navigationBarBackButtonHidden(true)
                case .parentGate:
                    ParentalGateView(viewModel: ParentalGateViewModel(navigationManager: navigationManager, onSuccess: {}))
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
        .fullScreenCover(item: $gateManager.gateDestination) { destination in
            ParentalGateView(
                viewModel: ParentalGateViewModel(
                    navigationManager: navigationManager,
                    onSuccess: {
                        gateManager.gateDestination = nil
                        switch destination {
                        case .parentSettings:
                            navigationManager.goTo(.parentValue)
                            //                        case .reviewLogOnFirstLog:
                        case .reviewLogFromGarden(let log):
                            navigationManager.goTo(.relog(log: log))
                            //                        case .checklistUpdate:
                        }
                    }
                )
            )
        }
    }
    
    @ViewBuilder
    var fieldView: some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            LazyVGrid(columns: [GridItem(.fixed(110), spacing: 13), GridItem(.fixed(110))], spacing: 60) {
                
                ForEach(0..<4, id: \.self) { (index: Int) in
                    
                    if index < viewModel.logs.count {
                        let log = viewModel.logs[index]
                        let fieldState = FieldState(state: log.state ?? "x")
                        
                        fieldCardViewBuilder(for: log, type: fieldState, positionIndex: index)
                    } else {
                        fieldCardViewBuilder(for: nil, type: .empty, positionIndex: index)
                    }
                }
            }
            .offset(y: 40)
        }
    }
    
    @ViewBuilder
    func fieldCardViewBuilder(for log: MsLog?, type: FieldState, positionIndex: Int) -> some View {
        let image: UIImage? = {
            if let imagePath = log?.imagePath {
                return ImageStorage.loadImage(from: imagePath)
            } else {
                return nil
            }
        }()
        
        let colorForEmptyState: Color? = {
            if type == .empty {
                return getEmptyColor(for: positionIndex)
            }
            return nil
        }()
        
        FieldCardView(type: type, logImage: image, isShovelMode: viewModel.isShovelMode, emptyStateColor: colorForEmptyState) {
            viewModel.onFieldTapped(
                forLog: log,
                forFieldType: type,
                context: navigationManager
            )
        } onCTAButtonTapped: {
            print("CTA button tapped")
            viewModel.handleCTAButtonTapped(forLog: log, withType: type, context: navigationManager, logImage: image)
        }
        
    }
    
    private func getEmptyColor(for position: Int) -> Color {
        switch position {
        case 0:
            return Color(hex: "#AD7151")
        case 1:
            return Color(hex: "#8D5739")
        case 2:
            return Color(hex: "#7C4C32")
        case 3:
            return Color(hex: "#965C40")
        default:
            return Color(hex: "#AD7151")
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
                navigationManager.goTo(.collectible)
                print("Pindah ke collectible")
            },
            cornerRadius: 24,
            width: 64,
            type: .normal
        )
    }
    
    var parentButton: some View {
        CustomButton(
            backgroundColor: ColorPalette.yellow600,
            foregroundColor: ColorPalette.yellow400,
            textColor: ColorPalette.yellow50,
            image: "parentButton",
            imageHeight: 60,
            action: {
                gateManager.gateDestination = .parentSettings
            },
            cornerRadius: 24,
            width: 64,
            type: .normal
        )
    }
    
}

#Preview {
    GardenHomeView()
        .environmentObject(NavigationManager())
        .environmentObject(ParentalGateManager())
}
