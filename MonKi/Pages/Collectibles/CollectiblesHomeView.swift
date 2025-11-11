//
//  CollectiblesHomeView.swift
//  MonKi
//
//  Created by William on 29/10/25.
//

import SwiftUI

struct CollectiblesHomeView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let background: String = "CanvasBackground"
    let background2: String = "blueDiagonalRectangle"
    let background3: String = "CanvasBackgroundButton"
    let background4: String = "CollectiblesPaperNote"
    @StateObject private var viewModel: CollectiblesHomeViewModel
    
    let onPreviousButtonTap: () -> Void
    let onNextButtonTap: () -> Void
    
    let height: CGFloat = 100.0
    
    init() {
        let viewModel = CollectiblesHomeViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
        
        self.onPreviousButtonTap = {
            withAnimation {
                viewModel.decrementPage()
            }
        }
        self.onNextButtonTap = {
            withAnimation {
                viewModel.incrementPage()
            }
        }
    }
    
    var body: some View {
        ZStack {
            backgroundBuilder
            
            contentView
            
            VStack {
                cancelButton
                
                Spacer()
                
                paginationView
            }
            .padding(.horizontal, 24)
            .padding(.top, 80)
            .padding(.bottom, 57)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var contentView: some View {
        ZStack {
            Image(background4)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
            
            archivedListView
                .frame(width: 300, height: 500)
                .offset(y: 20)
        }
    }
    
    //TODO: implement archived view
    var archivedListView: some View {
        LazyVGrid(columns: columns, spacing: 50) {
            ForEach(viewModel.pagedArchivedLogs, id: \.objectID) { log in
                archivedLogCard(log: log)
            }
            
            if viewModel.pagedArchivedLogs.count < 4 {
                ForEach(0..<(4 - viewModel.pagedArchivedLogs.count), id: \.self) { _ in
                    emptyLogCard()
                }
            }
        }
    }
    
    @ViewBuilder
    func emptyLogCard() -> some View {
        VStack(spacing: 5) {
            ChildLogStatusView(isEmpty: true)
            Text("?")
                .font(.system(size: 96, weight: .bold, design: .rounded))
                .foregroundStyle(ColorPalette.neutral300)
                .frame(height: height)
        }
        .frame(minHeight: 208, maxHeight: 208)
    }
    
    @ViewBuilder
    func archivedLogCard(log: MsLog) -> some View {
        VStack(spacing: 5) {
            if let tags = log.beneficialTags {
                ChildLogStatusView(happyLevel: HappyLevelEnum(level: Int(log.happyLevel)), firstTagTitle: IOHelper.expandTags(tags)[safe: 0], secondTagTitle: IOHelper.expandTags(tags)[safe: 1])
            }
            if let imagePath = log.imagePath, let image = ImageStorage.loadImage(from: imagePath){
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: height)
            }
        }
        .frame(minHeight: 208, maxHeight: 208)
    }
    
    var paginationView: some View {
        HStack {
            leftButton
            
            Spacer()
            
            HStack {
                Text("\(viewModel.currIndex+1)")
                    .font(.title2Emphasized)

                Text("dari \(viewModel.maxPage)")
                    .font(.title2Regular)
            }
            .foregroundStyle(ColorPalette.neutral50)
            
            Spacer()
            
            rightButton
        }
    }
    
    @ViewBuilder
    var leftButton: some View {
        if viewModel.currIndex == 0 {
            CustomButton(
                colorSet: .disabled,
                font: .system(size: 20, weight: .black, design: .rounded),
                image: "arrow.left",
                action: onPreviousButtonTap,
                cornerRadius: 24,
                width: 64,
                type: .normal,
                isDisabled: true
            )
        } else {
            CustomButton(
                backgroundColor: ColorPalette.yellow600,
                foregroundColor: ColorPalette.yellow400,
                textColor: ColorPalette.neutral50,
                font: .system(size: 20, weight: .black, design: .rounded),
                image: "arrow.left",
                action: onPreviousButtonTap,
                cornerRadius: 24,
                width: 64,
                type: .normal
            )
        }
    }
    
    @ViewBuilder
    var rightButton: some View {
        if viewModel.currIndex == viewModel.maxPage-1 {
            CustomButton(
                colorSet: .disabled,
                font: .system(size: 20, weight: .black, design: .rounded),
                image: "arrow.right",
                action: onNextButtonTap,
                cornerRadius: 24,
                width: 64,
                type: .normal,
                isDisabled: true
            )
        } else {
            CustomButton(
                backgroundColor: ColorPalette.yellow600,
                foregroundColor: ColorPalette.yellow400,
                textColor: ColorPalette.neutral50,
                font: .system(size: 20, weight: .black, design: .rounded),
                image: "arrow.right",
                action: onNextButtonTap,
                cornerRadius: 24,
                width: 64,
                type: .normal
            )
        }
    }
    
    var cancelButton: some View {
        HStack {
            CustomButton(
                colorSet: .destructive,
                font: .system(size: 20, weight: .black, design: .rounded),
                image: "xmark",
                action: navigationManager.popLast,
                cornerRadius: 24,
                width: 64,
                type: .normal
            )
            Spacer()
        }
    }
    
    var backgroundBuilder: some View {
        ZStack {
            Image(background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Image(background2)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
                .offset(x: 100)
            
            VStack {
                Image(background3)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                
                Spacer()
            }
            
        }
    }
}

#Preview {
    CollectiblesHomeView()
        .environmentObject(NavigationManager())
}
