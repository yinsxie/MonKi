//
//  HomeView.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

import SwiftUI

enum HomeState {
    case logging
    case garden
}

struct HomeView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    @StateObject var gardenViewModel = GardenViewModel()
    @StateObject var childlogViewModel = ChildLogViewModel()
    @StateObject var parentViewModel = ParentHomeViewModel()
    
    @State private var pageIndex: Int = 1
    
    var currentView: HomeState {
        print("pageIndex: \(pageIndex)")
        return pageIndex % 2 == 1 ? .logging : .garden
    }
    
    @State private var dragOffset: CGFloat = 0
    
    private let animationDuration: TimeInterval = 0.3
    
    var body: some View {
        NavigationStack(path: $navigationManager.navigationPath) {
            GeometryReader { geometry in
                
                let baseOffset = CGFloat(-pageIndex) * geometry.size.width
                
                ZStack(alignment: .topLeading) {
                    
                    // --- LAYER 1: SLIDING CONTENT ---
                    HStack(spacing: 0) {
                        // [Page 0]
                        gardenPageContent(geometry: geometry)
                            .frame(width: geometry.size.width)
                        
                        // [Page 1] - START HERE
                        loggingPageContent(geometry: geometry)
                            .frame(width: geometry.size.width)
                        
                        // [Page 2]
                        gardenPageContent(geometry: geometry)
                            .frame(width: geometry.size.width)
                        
                        // [Page 3]
                        loggingPageContent(geometry: geometry)
                            .frame(width: geometry.size.width)
                    }
                    .ignoresSafeArea(edges: .all)
                    .offset(x: baseOffset + dragOffset)
                    
                    // --- LAYER 2: FIXED TOP NAV ---
                    VStack {
                        topNav
                        Spacer()
                    }
                    .frame(width: geometry.size.width)

                    // --- LAYER 3: FIXED BOTTOM/CENTER CONTROLS ---
                    VStack {
                        Spacer()
                        bottomControls
                        Spacer()
                    }
                    .frame(width: geometry.size.width)
                    .padding(.bottom, 100)

                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.dragOffset = value.translation.width
                        }
                        .onEnded { value in
                            let swipeThreshold = geometry.size.width / 4
                            var newIndex = pageIndex
                            
                            if value.translation.width < -swipeThreshold {
                                newIndex += 1
                            } else if value.translation.width > swipeThreshold {
                                newIndex -= 1
                            }
                            
                            withAnimation(.easeInOut(duration: animationDuration)) {
                                dragOffset = 0
                                pageIndex = newIndex
                            }
                            
                            handleWrapAround()
                        }
                )
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationDestination(for: MainRoute.self) { route in
                switch route {
                case .childLog(let childLogRoute):
                    childLogRoute.delegateView()
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(childlogViewModel)
                case .childGarden(let childGardenRoute):
                    childGardenRoute.delegateView()
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(gardenViewModel)
                case .parentHome(let parentRoute):
                    parentRoute.delegateView()
                        .environmentObject(parentViewModel)
                        .navigationBarBackButtonHidden(true)
                case .reLog(let log):
                    ReLogNavigationContainer(logToEdit: log)
                        .navigationBarBackButtonHidden(true)
                case .parentValue:
                    ParentValueTagView()
                case .parentalGate:
                    ParentalGateView(
                        viewModel: ParentalGateViewModel(
                            navigationManager: navigationManager,
                            onSuccess: {
                                navigationManager.replaceTop(with: .parentHome(.home))
                            }
                        )
                    )
                    .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
    
    /// Instantly jumps to the other copy of the page to allow infinite scrolling
    func handleWrapAround() {
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            if pageIndex == 3 {
                pageIndex = 1
            } else if pageIndex == 0 {
                pageIndex = 2
            }
        }
    }
    
    // MARK: - Sliding Page Content
    func loggingPageContent(geometry: GeometryProxy) -> some View {
        ZStack {
            loggingBackground(geometry: geometry)
        }
    }
    
    func gardenPageContent(geometry: GeometryProxy) -> some View {
        ZStack {
            gardenBackground(geometry: geometry)
        }
    }

    // MARK: - Fixed Controls
    var topNav: some View {
        HStack {
            CustomButton(
                backgroundColor: ColorPalette.yellow600,
                foregroundColor: ColorPalette.yellow400,
                textColor: ColorPalette.yellow50,
                image: "parentButton",
                imageHeight: 60,
                action: {
                    navigationManager.goTo(.parentHome(.home))
                },
                cornerRadius: 24,
                width: 64,
                type: .normal
            )
            
            Spacer()
            navButton(imageName: "star.fill") {
                navigationManager.goTo(.parentValue)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    var bottomControls: some View {
        HStack(alignment: .center) {
            
            arrowButton(imageName: "arrow.left") {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    pageIndex -= 1
                }
                handleWrapAround()
            }
            
            Spacer()

            centerCardButton
            
            Spacer()

            arrowButton(imageName: "arrow.right") {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    pageIndex += 1
                }
                handleWrapAround()
            }
        }
        .padding(.horizontal, 20)
    }
    
    var centerCardButton: some View {
        Button {
            if currentView == .logging {
                navigationManager.goTo(.childLog(.logInput))
            } else {
                navigationManager.goTo(.childGarden(.home(logToBePlanted: nil)))
            }
        } label: {
            ZStack {
                // TODO: Replace with design asset
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(width: 150, height: 150)
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                
                // This content will now fade in/out
                VStack(spacing: 12) {
                    Image(systemName: currentView == .logging ? "pencil.and.scribble" : "leaf.fill")
                        .font(.system(size: 40, weight: .medium))
                    Text(currentView == .logging ? "Catat" : "Taman")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                }
                .foregroundColor(currentView == .logging ? .blue : .green)
            }
        }
        .id("centerCard_\(currentView)")
        .transition(.opacity.animation(.easeInOut(duration: 0.2)))
    }

    // MARK: - Backgrounds
    func loggingBackground(geometry: GeometryProxy) -> some View {
        ZStack {
            Image("homeLogging")
        }
    }
    
    func gardenBackground(geometry: GeometryProxy) -> some View {
        ZStack {
            Image("homeGarden")
        }
    }

    // MARK: - Helper Views
    func navButton(imageName: String, action: @escaping () -> Void) -> some View {
        CustomButton(
            backgroundColor: ColorPalette.yellow600,
            foregroundColor: ColorPalette.yellow400,
            textColor: ColorPalette.yellow50,
            font: .system(size: 20, weight: .black, design: .rounded),
            image: imageName,
            action: action,
            cornerRadius: 24,
            width: 64,
            type: .normal
        )
    }
    
    func arrowButton(imageName: String, action: @escaping () -> Void) -> some View {
        CustomButton(
            backgroundColor: ColorPalette.yellow600,
            foregroundColor: ColorPalette.yellow400,
            textColor: ColorPalette.neutral50,
            font: .system(size: 20, weight: .black, design: .rounded),
            image: imageName,
            action: action,
            cornerRadius: 24,
            width: 72,
            type: .normal
        )
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationManager())
}
