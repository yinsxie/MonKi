//
//  ChildLogNavigationContainer.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 27/10/25.
//

import PhotosUI
import SwiftUI

struct ChildLogNavigationContainer: View {
    @StateObject private var viewModel = ChildLogViewModel()
    
    var body: some View {
        ChildLogNavigationView(
            currentIndex: $viewModel.currentIndex,
            pageCount: 3,
            onClose: { print("Navigation closed") },
            customNextAction: { defaultAction in
                viewModel.handleNextAction(defaultAction: defaultAction)
            },
            customBackAction: {
                viewModel.handleBackAction()
            },
            isNextDisabled: viewModel.shouldDisableNext(),
            content: {
                Group {
                    switch viewModel.currentIndex {
                    case 0:
                        SelectModePage(
                            selectedMode: $viewModel.selectedMode,
                            isGalleryPermissionGranted: $viewModel.isGalleryPermissionGranted,
                            viewModel: viewModel
                        )
                        
                    case 1:
                        if viewModel.selectedMode == "Draw" {
                            DrawPage()
                        } else {
                            UploadPage(viewModel: viewModel)
                        }
                        
                    case 2:
                        FinalImagePage(processedImage: viewModel.backgroundRemover.resultImage)
                        
                    default:
                        EmptyView()
                    }
                }
            }
        )
        // MARK: - Photo Picker
        .photosPicker(
            isPresented: $viewModel.showPhotoPicker,
            selection: $viewModel.selectedItem,
            matching: .images)
        .onChange(of: viewModel.selectedItem) { _, newItem in
            Task {
                await viewModel.handleImageSelection(newItem)
                
                if newItem != nil {
                    await MainActor.run {
                        withAnimation {
                            viewModel.currentIndex = 1
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
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please enable photo library access in Settings to use the Gallery feature.")
        }
        .alert(item: $viewModel.backgroundRemover.alert) { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: .default(Text("OK")) {
                    withAnimation {
                        viewModel.currentIndex = 1
                        viewModel.selectedItem = nil
                        viewModel.backgroundRemover.partialReset()
                    }
                }
            )
        }
    }
}

#Preview {
    ChildLogNavigationContainer()
}
