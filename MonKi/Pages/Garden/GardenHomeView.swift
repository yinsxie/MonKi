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
    
    @FetchRequest(
        entity: MsLog.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MsLog.createdAt, ascending: true)],
        predicate: NSPredicate(format: "state != %@", LogState.logDone.stringValue)
    ) var gardenLogs: FetchedResults<MsLog>
    
    var body: some View {
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
                footerButtonView(totalLogs: gardenLogs.count)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 57)
            
            popUpView
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
//            viewModel.logRepo.fetchGardenLogs()
        }
        
    }
    
    @ViewBuilder
    var fieldView: some View {
        // no need manual loading with @FetchRequest
        //        if viewModel.isLoading {
        //            ProgressView()
        //        } else {
        
        let pagedLogs = viewModel.getPagedLogs(from: gardenLogs)
        
        LazyVGrid(columns: [GridItem(.fixed(110), spacing: 13), GridItem(.fixed(110))], spacing: 60) {
            
            // hardcode version (before pagination)
            //                ForEach(0..<4, id: \.self) { (index: Int) in
            //
            //                    if index < viewModel.logs.count {
            //                        let log = viewModel.logs[index]
            //                        let fieldState = FieldState(state: log.state ?? "x")
            //
            //                        fieldCardViewBuilder(for: log, type: fieldState, positionIndex: index)
            //                    } else {
            //                        fieldCardViewBuilder(for: nil, type: .empty, positionIndex: index)
            //                    }
            //                }
            
            ForEach(0..<viewModel.pageSize, id: \.self) { (index: Int) in
                if index < pagedLogs.count {
                    let log = pagedLogs[index]
                    let fieldState = FieldState(state: log.state ?? "x")
                    
                    fieldCardViewBuilder(for: log, type: fieldState, positionIndex: index)
                } else {
                    fieldCardViewBuilder(for: nil, type: .empty, positionIndex: index)
                }
            }
        }
        .offset(y: 40)
        //        }
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
                gateManager: gateManager,
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
    
    func footerButtonView(totalLogs: Int) -> some View {
        HStack {
            leftButton(totalLogs: totalLogs)
            
            Spacer()
            
            (
                Text("\(viewModel.currIndex + 1)")
                    .fontWeight(.bold)
                +
                Text(" dari \(viewModel.maxPage(totalLogs: totalLogs))")
            )
            .font(.system(size: 24, weight: .regular, design: .rounded))
            .foregroundStyle(.white)
            .opacity(viewModel.maxPage(totalLogs: totalLogs) == 1 ? 0 : 1)
            
            Spacer()
            
            rightButton(totalLogs: totalLogs)
            
        }
    }
    
    @ViewBuilder
    func leftButton(totalLogs: Int) -> some View {
        let isDisabled = viewModel.currIndex == 0
        
        CustomButton(
            backgroundColor: ColorPalette.yellow600,
            foregroundColor: ColorPalette.yellow400,
            textColor: ColorPalette.yellow50,
            font: .system(size: 20, weight: .black, design: .rounded),
            image: "arrow.left",
            action: {
                withAnimation {
                    viewModel.decrementPage()
                }
            },
            cornerRadius: 24,
            width: 64,
            type: .normal
        )
        .opacity(isDisabled ? 0 : 1)
    }
    
    @ViewBuilder
    func rightButton(totalLogs: Int) -> some View {
        let isDisabled = viewModel.currIndex == viewModel.maxPage(totalLogs: totalLogs) - 1
        
        CustomButton(
            backgroundColor: ColorPalette.yellow600,
            foregroundColor: ColorPalette.yellow400,
            textColor: ColorPalette.yellow50,
            font: .system(size: 20, weight: .black, design: .rounded),
            image: "arrow.right",
            action: {
                withAnimation {
                    viewModel.incrementPage(totalLogs: totalLogs)
                }
            },
            cornerRadius: 24,
            width: 64,
            type: .normal
        )
        .opacity(isDisabled ? 0 : 1)
        
    }
    
    var collectibleButton: some View {
        CustomButton(
            backgroundColor: ColorPalette.yellow600,
            foregroundColor: ColorPalette.yellow400,
            textColor: ColorPalette.yellow50,
            font: .system(size: 20, weight: .black, design: .rounded),
            image: "book.pages.fill",
            action: {
                navigationManager.goTo(.main(.collectible))
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
