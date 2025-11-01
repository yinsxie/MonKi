//
//  ChildLogNavigationContainer.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 27/10/25.
//

import PhotosUI
import SwiftUI
import CoreData

struct ChildLogNavigationContainer: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel: ChildLogViewModel

    init() {
        let repository = LogRepository()
        _viewModel = StateObject(wrappedValue: ChildLogViewModel())
    }

    var body: some View {
        ChildLogNavigationView(
            currentIndex: $viewModel.currentIndex,
            pageCount: ChildLogPageEnum.allCases.count + ChildLogTagEnum.allCases.count,
            isProgressBarHidden: viewModel.shouldHideProgressBar,
            onClose: {
                print("Navigation closed via close button.")
                navigationManager.popLast()
            },
            customNextAction: { defaultCloseAction in
                viewModel.handleNextAction(defaultAction: defaultCloseAction)
            },
            customBackAction: {
                viewModel.handleBackAction()
            },
            isNextDisabled: viewModel.isNextDisabled,
            content: {
                ChildLogRouter(viewModel: viewModel)
                    .environmentObject(viewModel.canvasViewModel)
            }
        )
        // MARK: - Photo Picker Setup
        .photosPicker(
            isPresented: $viewModel.showPhotoPicker,
            selection: $viewModel.selectedItem,
            matching: .images
        )
        // MARK: - Image Selection Listener (Gallery)
        .onChange(of: viewModel.selectedItem) { _, newItem in
            Task {
                await viewModel.handleImageSelection(newItem)

                if viewModel.selectedItem != nil && viewModel.finalProcessedImage != nil {
                        await MainActor.run {
                            withAnimation {
                                viewModel.currentIndex = ChildLogPageEnum.mainInput.rawValue
                            }
                        }
                }
            }
        }
        
        // MARK: - Alerts
        .alert("Photo Access Required", isPresented: $viewModel.showingPermissionAlert) {
             Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
             }
             Button("Cancel", role: .cancel) {
                if viewModel.inputSelectedMode == "Gallery" { viewModel.inputSelectedMode = nil }
             }
        } message: {
             Text("Please enable photo library access in Settings to use the Gallery feature.")
        }
        .alert(item: $viewModel.backgroundRemover.alert) { alertInfo in
             Alert(
                title: Text(alertInfo.title),
                message: Text(alertInfo.message),
                dismissButton: .default(Text("OK")) {
                    viewModel.selectedItem = nil
                    viewModel.previewImage = nil
                    viewModel.finalProcessedImage = UIImage()
                    viewModel.backgroundRemover.partialReset()
                    viewModel.imageLoadError = nil
                }
             )
        }
         // TODO: Add alert for Canvas processing errors if needed
    }
}
