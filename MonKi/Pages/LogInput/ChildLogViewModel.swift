//
//  ChildLogViewModel.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 27/10/25.
//

import SwiftUI
import PhotosUI

@MainActor
internal class ChildLogViewModel: ObservableObject {
    // MARK: - Navigation & State
    @Published var currentIndex: Int = 0
    @Published var selectedMode: String?
    @Published var isGalleryPermissionGranted: Bool = false
    @Published var showingPermissionAlert: Bool = false
    
    // MARK: - Image Handling
    @Published var selectedItem: PhotosPickerItem?
    @Published var previewImage: UIImage?
    @Published var imageLoadError: String?
    @Published var showPhotoPicker = false
    
    // MARK: - Background Remover
    @Published var backgroundRemover = BackgroundRemoverViewModel()
    
    // MARK: - Permission
    func requestGalleryPermission(completion: @escaping (Bool) -> Void) {
        PhotoPermissionService.shared.requestPermission { [weak self] granted in
            Task { @MainActor in
                guard let self else { return }
                self.isGalleryPermissionGranted = granted
                if !granted {
                    self.showingPermissionAlert = true
                } else {
                    self.selectedMode = "Gallery"
                }
                completion(granted)
            }
        }
    }
    
    // MARK: - Image Selection
    func handleImageSelection(_ item: PhotosPickerItem?, skipProcessing: Bool = false) async {
        imageLoadError = nil
        
        guard let item else {
            previewImage = nil
            backgroundRemover.reset()
            handleNoImageSelected()
            return
        }
        
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data) else {
                throw URLError(.cannotDecodeRawData)
            }
            
            previewImage = uiImage
            backgroundRemover.originalImage = uiImage
            
            if !skipProcessing {
                await backgroundRemover.processSelectedImage(item)
            }
        } catch {
            previewImage = nil
            imageLoadError = "Failed to load image. Please try another photo."
            backgroundRemover.reset()
            handleNoImageSelected()
        }
    }
    
    // MARK: - Navigation Actions
    func handleNextAction(defaultAction: @escaping () -> Void) {
        switch currentIndex {
        case 0:
            if selectedMode == "Gallery" {
                requestGalleryPermission { [weak self] granted in
                    guard let self else { return }
                    if granted {
                        Task { @MainActor in
                            self.showPhotoPicker = true
                        }
                    }
                }
            } else if selectedMode == "Draw" {
                withAnimation { currentIndex = 1 }
            }
            
        case 1:
            if selectedMode == "Draw" ||
                (selectedMode == "Gallery" &&
                 selectedItem != nil &&
                 !backgroundRemover.isProcessing) {
                withAnimation { currentIndex = 2 }
            }
            
        default:
            defaultAction()
        }
    }
    
    func handleNoImageSelected() {
        if selectedMode == "Gallery", currentIndex == 1 {
            withAnimation {
                currentIndex = 0
                selectedItem = nil
            }
        }
    }

    func handleBackAction() {
        if currentIndex == 2 {
            withAnimation {
                currentIndex = 1
                if selectedMode == "Gallery" {
                    backgroundRemover.partialReset()
                }
            }
        } else if currentIndex == 1 {
            withAnimation {
                currentIndex = 0
                selectedItem = nil
                backgroundRemover.reset()
            }
        }
    }
    
    func shouldDisableNext() -> Bool {
        let isModeInvalid = selectedMode?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let isProcessing = backgroundRemover.isProcessing
        let isUploadInvalid = selectedMode == "Gallery" && currentIndex == 1 && selectedItem == nil

        if currentIndex == 0 {
            return isModeInvalid
        } else if currentIndex == 1 {
            return isProcessing || isUploadInvalid
        } else {
            return false
        }
    }
}
