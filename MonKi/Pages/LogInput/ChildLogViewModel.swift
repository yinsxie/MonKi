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
    
    // MARK: - Page
    var currentPage: ChildLogPageEnum {
        return ChildLogPageEnum(rawValue: currentIndex) ?? .selectMode
    }
    
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
        switch currentPage {
        case .selectMode:
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
                withAnimation { currentIndex = ChildLogPageEnum.mainInput.rawValue }
            }
            
        case .mainInput:
            if selectedMode == "Draw" ||
                (selectedMode == "Gallery" &&
                 selectedItem != nil &&
                 !backgroundRemover.isProcessing) {
                withAnimation { currentIndex = ChildLogPageEnum.finalImage.rawValue }
            }
            
        case .finalImage:
            defaultAction()
        }
    }
    
    func handleNoImageSelected() {
        if selectedMode == "Gallery", currentPage == .mainInput {
            withAnimation {
                currentIndex = ChildLogPageEnum.selectMode.rawValue
                selectedItem = nil
            }
        }
    }
    
    func handleBackAction() {
        switch currentPage {
        case .finalImage:
            withAnimation {
                currentIndex = ChildLogPageEnum.mainInput.rawValue
                if selectedMode == "Gallery" {
                    backgroundRemover.partialReset()
                }
            }
        case .mainInput:
            withAnimation {
                currentIndex = ChildLogPageEnum.selectMode.rawValue
                selectedItem = nil
                backgroundRemover.reset()
            }
        case .selectMode:
            break
        }
    }
    
    func shouldDisableNext() -> Bool {
        let isModeInvalid = selectedMode?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let isProcessing = backgroundRemover.isProcessing
        let isUploadInvalid = selectedMode == "Gallery" && currentPage == .mainInput && selectedItem == nil
        
        switch currentPage {
        case .selectMode:
            return isModeInvalid
        case .mainInput:
            return isProcessing || isUploadInvalid
        case .finalImage:
            return false
        }
    }
    
    var shouldHideProgressBar: Bool {
        return selectedMode == "Draw" && currentPage == .mainInput
    }
}
