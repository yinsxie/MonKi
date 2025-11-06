//
//  ReflectionGuideStoryView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 29/10/25.
//

import SwiftUI
import CoreData // for preview purposes

struct ReflectionGuideStoryView: View {
    
    let log: MsLog
    @StateObject private var viewModel: ReflectionGuideStoryViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    init(log: MsLog) {
        self.log = log
        _viewModel = StateObject(wrappedValue: ReflectionGuideStoryViewModel(log: log))
    }
    
    var body: some View {
        ZStack {
            
            ColorPalette.yellow500.ignoresSafeArea(.all)
            
            if !viewModel.pages.isEmpty && viewModel.currentPageIndex < viewModel.pages.count {
                Image(viewModel.pages[viewModel.currentPageIndex].imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .ignoresSafeArea(.container, edges: .bottom)
                    .id(viewModel.currentPageIndex)
            }
            
            if let imagePath = log.imagePath, let uiImage = ImageStorage.loadImage(from: imagePath) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
                    .offset(x: 125, y: 180)
            }
            
            VStack(alignment: .leading, spacing: 24) {
                
                closeButton
                    .padding(.horizontal, 24)
                
                StoryProgressBar(
                    totalSegments: viewModel.pages.count,
                    currentSegment: viewModel.currentPageIndex,
                    progress: viewModel.progress // Pass the animating progress
                )
                .padding(.horizontal, 24)
                
                ZStack {
                    if !viewModel.pages.isEmpty && viewModel.currentPageIndex < viewModel.pages.count {
                        StoryPageView(page: viewModel.pages[viewModel.currentPageIndex])
                            .padding(.horizontal, 20)
                            .frame(maxHeight: .infinity)
                    } else {
                        Spacer()
                    }
                    
                    tapNavigationOverlay
                    
                }
                .frame(maxHeight: .infinity)
                
                let isLastPage = viewModel.currentPageIndex == viewModel.pages.count - 1
                
                if isLastPage {
                    HStack {
                        Spacer()
                        finishButton
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
            }
            .padding(.top, 20)
            
            //Alerts
            if viewModel.showModalityOnStoryViewCancelButtonTapped {
                popUpView
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Start the timer when the view appears
            viewModel.startTimer()
        }
        .onDisappear {
            // Stop the timer when the view disappears
            viewModel.stopTimer()
        }
    }
    
    // MARK: - Subviews
    private var closeButton: some View {
        CustomButton(
            colorSet: .destructive,
            font: .system(size: 20, weight: .black, design: .rounded),
            image: "xmark",
            action: {
                withAnimation {
                    viewModel.setShowModalityOnStoryViewCancelButtonTapped(to: true)
                }
            },
            cornerRadius: 24,
            width: 64,
            type: .normal
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var finishButton: some View {
        
        let isEnabled = viewModel.progress >= 1.0
        
        return CustomButton(
            text: "Selesai Ngobrol",
            colorSet: isEnabled ? .primary : .disabled,
            font: .headlineEmphasized,
            imageRight: "arrow.right",
            action: {
                viewModel.rejectLog()
            },
            cornerRadius: 24,
            width: 189,
            type: .normal
        )
        .disabled(!isEnabled)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
    
    /// An overlay for handling taps to navigate
    private var tapNavigationOverlay: some View {
        HStack(spacing: 0) {
            // Left Side (Regress)
            Rectangle()
                .fill(Color.black.opacity(0.001))
                .onTapGesture {
                    viewModel.regressStory()
                }
            
            // Right Side (Advance)
            Rectangle()
                .fill(Color.black.opacity(0.001))
                .onTapGesture {
                    viewModel.advanceStory()
                }
        }
        .ignoresSafeArea()
        // Add gesture for pausing
        .onLongPressGesture(
            minimumDuration: 0.1,
            pressing: { isPressing in
                if isPressing {
                    viewModel.pauseTimer()
                } else {
                    viewModel.resumeTimer()
                }
            },
            perform: { }
        )
    }
    
    var popUpView: some View {
        PopUpView(
            type: ParentSectionModalType.onStoryViewCancelButtonTapped(
                onPrimaryTap: {
                    withAnimation {
                        viewModel.setShowModalityOnStoryViewCancelButtonTapped(to: false)
                    }
                },
                onSecondaryTap: {
                    withAnimation {
                        viewModel.setShowModalityOnStoryViewCancelButtonTapped(to: false)
                        viewModel.rejectLog()
                    }
                }
            )
        ){
            withAnimation {
                viewModel.setShowModalityOnStoryViewCancelButtonTapped(to: false)
            }
        }
        .zIndex(1)
    }
}
//
//#Preview {
//    
//    // 1. Mock NavigationManager
//    let mockNavManager = NavigationManager()
//    
//    // --- 2. Legacy In-Memory Core Data Setup (iOS 9 compatible) ---
//    
//    // Load the "MonKi" model
//    // 2. Make SURE your model file is named "MonKi.xcdatamodeld"
//    guard let modelURL = Bundle.main.url(forResource: "MonKi", withExtension: "momd") else {
//        fatalError("Failed to find data model file 'MonKi.momd'.")
//    }
//    
//    // Load the model
//    guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
//        fatalError("Failed to load model from \(modelURL).")
//    }
//    
//    // Create the store coordinator
//    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
//    
//    // Add an in-memory store (the old way)
//    do {
//        try coordinator.addPersistentStore(
//            ofType: NSInMemoryStoreType, // This is the key part
//            configurationName: nil,
//            at: nil,
//            options: nil
//        )
//    } catch {
//        fatalError("Failed to create in-memory store: \(error)")
//    }
//    
//    // Create the context
//    let previewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//    previewContext.persistentStoreCoordinator = coordinator
//    // --- End of legacy setup ---
//    
//    // 3. Create a realistic mock log
//    let mockLog = MsLog(context: previewContext)
//    mockLog.id = UUID()
//    mockLog.imagePath = "icecream_placeholder"
//    mockLog.isHappy = true
//    mockLog.isBeneficial = false
//    mockLog.beneficialTags = "toy;expensive"
//    mockLog.state = "created"
//    mockLog.createdAt = Date()
//    mockLog.updatedAt = Date()
//    
//    // 4. Return your view
//    return ReflectionGuideStoryView(log: mockLog)
//        .environmentObject(mockNavManager)
//        .environment(\.managedObjectContext, previewContext)
//}
